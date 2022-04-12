#!/usr/bin/env python3


async def generate(hub, **pkginfo):
    github_user = "k3d-io"
    github_repo = "k3d"

    release_info = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)

    golang_deps = await hub.pkgtools.golang.generate_gosum_from_artifact(release_info["artifacts"][0])
    release_info["artifacts"].extend(golang_deps["gosum_artifacts"])

    k3s_channels_data = await hub.pkgtools.fetch.get_page("https://update.k3s.io/v1-release/channels", is_json=True)

    k3s_stable_channel = next(channel for channel in k3s_channels_data["data"] if channel["id"] == "stable")
    k3s_stable_version = k3s_stable_channel["latest"]

    patch_version = "".join([s for s in k3s_stable_version if s.isdigit()])

    release_info["version"] += "_p" + patch_version

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        **release_info,
        github_user=github_user,
        github_repo=github_repo,
        gosum=golang_deps["gosum"],
        k3s_tag=k3s_stable_version,
    )
    ebuild.push()
