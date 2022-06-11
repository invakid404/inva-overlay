#!/usr/bin/env python


async def generate(hub, **pkginfo):
    github_user = "thedodd"
    github_repo = "trunk"

    latest_release = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)
    pkginfo.update(latest_release)

    cargo_artifacts = await hub.pkgtools.rust.generate_crates_from_artifact(pkginfo["artifacts"][0])
    pkginfo["artifacts"].extend(cargo_artifacts["crates_artifacts"])

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
        crates=cargo_artifacts["crates"],
    )

    ebuild.push()
