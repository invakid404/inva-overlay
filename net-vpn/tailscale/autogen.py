#!/usr/bin/env python


async def generate(hub, **pkginfo):
    github_user = github_repo = pkginfo["name"]

    release_data = await hub.pkgtools.github.release_gen(hub, github_user, github_repo)
    pkginfo.update(release_data)

    gocache_artifact = await hub.pkgtools.golang.generate_gocache_artifact(hub, pkginfo)
    pkginfo["artifacts"].append(gocache_artifact)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        github_user=github_user,
        github_repo=github_repo,
    )
    ebuild.push()
