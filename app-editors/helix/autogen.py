#!/usr/bin/env python3


async def generate(hub, **pkginfo):
    github_user = "helix-editor"
    github_repo = pkginfo["name"]

    release_data = await hub.pkgtools.github.release_gen(hub, github_user,
            github_repo, tarball="helix-{version}-source.tar.xz")

    source_artifact, = release_data["artifacts"]

    crates_data = await hub.pkgtools.rust.generate_crates_from_artifact(source_artifact, src_dir_glob="")
    release_data["artifacts"].extend(crates_data["crates_artifacts"])

    pkginfo.update(release_data)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        crates=crates_data["crates"],
    )
    ebuild.push()
