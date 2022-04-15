#!/usr/bin/env python3


async def generate(hub, **pkginfo):
    github_user = github_repo = "helm"

    release_info = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)
    pkginfo.update(release_info)

    golang_deps = await hub.pkgtools.golang.generate_gosum_from_artifact(pkginfo["artifacts"][0])

    pkginfo["artifacts"].extend(golang_deps["gosum_artifacts"])

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
        gosum=golang_deps["gosum"],
    )
    ebuild.push()
