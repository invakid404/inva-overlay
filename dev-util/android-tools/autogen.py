#!/usr/bin/env python


async def generate(hub, **pkginfo):
    github_user = "nmeum"
    github_repo = "android-tools"

    # FIXME: Instead of replacing the patchlevel with a revision, an
    #        an underscore should be prepended instead, but the `version`
    #        library, provided by `packaging`, doesn't support patchlevels.
    transform = lambda tag: tag.replace("p", "-r")

    release_data = await hub.pkgtools.github.release_gen(hub, github_user, github_repo, transform=transform, tarball="android-tools-{tag}.tar.xz")
    pkginfo.update(release_data)

    ebuild = hub.pkgtools.ebuild.BreezyBuild(**pkginfo)
    ebuild.push()
