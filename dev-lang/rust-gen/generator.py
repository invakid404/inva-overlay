#!/usr/bin/env python3

from packaging import version


def build_indented_string(parts, indent_level=1):
    """
    Build a string from a list of lists, increasing indentation for every level.

    :param parts: list to flatten and join
    :type parts: list
    :param indent_level: current level of indentation
    :type indent_level: int
    :return: a properly indented string
    :rtype: str
    """
    res = []
    indentation = "\t" * indent_level

    for part in parts:
        if type(part) == list:
            res.append(build_indented_string(part, indent_level + 1))
        else:
            res.append(indentation + part)

    return "\n".join(res)


def get_release(release_data):
    """
    Find the latest release based on tag name.

    :param release_data: release data from github api
    :type release_data: list
    :return: latest release
    :rtype: dict
    """
    releases = list(filter(lambda x: x["prerelease"] is False and x["draft"] is False, release_data))
    return None if not releases else sorted(releases, key=lambda x: version.parse(x["tag_name"])).pop()


async def get_latest_version(hub, user, repo):
    """
    Fetch latest version for a GitHub repo.

    :param hub: metatools hub
    :type hub: Hub
    :param user: github user
    :type user: str
    :param repo: github repo
    :type repo: str
    :return: latest version
    :rtype str
    """
    release_data = await hub.pkgtools.fetch.get_page(f"https://api.github.com/repos/{user}/{repo}/releases",
                                                     is_json=True)

    latest_release = get_release(release_data)
    if latest_release is None:
        raise hub.pkgtools.ebuild.BreezyError(f"Can't find suitable release of {repo}")

    return latest_release["tag_name"]


def get_artifact_for_chost(hub, pkginfo, chost):
    """
    Get Rust artifact for given CHOST.

    :param hub: metatools hub
    :type hub: Hub
    :param pkginfo: current package info
    :type pkginfo: dict
    :param chost: chost to generate artifact for
    :type chost: str
    :return: artifact for chost
    :rtype Artifact
    """
    target_url = f"https://static.rust-lang.org/dist/rust-{pkginfo['version']}-{chost}.tar.xz"
    final_name = f"{pkginfo['name']}-{pkginfo['version']}-{chost}.tar.xz"

    return hub.pkgtools.ebuild.Artifact(url=target_url, final_name=final_name)


def generate_rust_arch_data(hub, pkginfo):
    """
    Generate arch-specific information for current Rust package: source artifacts, per-arch source URIs,
    and a utility to match CHOST to Rust ABI.

    :param hub: metatools hub
    :type hub: Hub
    :param pkginfo: current package info
    :type pkginfo: dict
    :return: artifacts, src uris and abi getter for current package
    :rtype dict
    """
    target_arches = pkginfo["target_arches"]

    artifacts = []
    src_uri_template = []
    abi_getter_cases = []

    for target_arch, chosts in target_arches.items():
        src_uri_template.append(f"{target_arch}? ( ")

        curr_uris = []
        for chost_data in chosts:
            curr_artifact = get_artifact_for_chost(hub, pkginfo, chost_data["chost"])

            curr_uris.append(curr_artifact.src_uri)

            artifacts.append(curr_artifact)

            abi_getter_cases.append(f"{chost_data['pattern']}) echo {chost_data['chost']};;")

        src_uri_template.append(curr_uris)
        src_uri_template.append(")")

    abi_getter_fn = [
        "local CTARGET=${1:-${CHOST}}",
        "case ${CTARGET%%*-} in",
        abi_getter_cases,
        "esac"
    ]

    return dict(
        artifacts=artifacts,
        src_uri_template=build_indented_string(src_uri_template),
        abi_getter_fn=build_indented_string(abi_getter_fn)
    )


async def preprocess_packages(hub, pkginfo_list):
    """
    Populate pkginfo with all necessary information to generate a Rust ebuild.

    :param hub: metatools hub
    :type hub: Hub
    :param pkginfo_list: a list of pkginfo dicts
    :type pkginfo_list: list
    """
    user = "rust-lang"
    repo = "rust"
    latest_version = await get_latest_version(hub, user, repo)

    for pkginfo in pkginfo_list:
        pkginfo["version"] = latest_version

        arch_data = generate_rust_arch_data(hub, pkginfo)

        pkginfo["src_uris"] = arch_data["src_uri_template"]
        pkginfo["artifacts"] = arch_data["artifacts"]
        pkginfo["abi_getter_fn"] = arch_data["abi_getter_fn"]

        yield pkginfo


async def generate(hub, **pkginfo):
    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo
    )

    ebuild.push()

    # Generate a virtual/rust ebuild for the current version
    virtual_ebuild = hub.pkgtools.ebuild.BreezyBuild(
        cat="virtual",
        name="rust",
        version=pkginfo["version"],
        template="rust-virtual.tmpl",
        template_path=pkginfo["template_path"],
    )

    virtual_ebuild.push()
