#!/usr/bin/env python3


async def generate(hub, **pkginfo):
    github_user = "evilmartians"
    github_repo = "lefthook"

    release_info = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)
    source_artifact, = release_info["artifacts"]

    golang_deps = await hub.pkgtools.golang.generate_gosum_from_artifact(source_artifact)

    release_info["artifacts"].extend(golang_deps["gosum_artifacts"])

    pkginfo.update(release_info)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
        gosum=golang_deps["gosum"],
    )
    ebuild.push()
