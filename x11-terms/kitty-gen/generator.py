#!/usr/bin/env python3


async def generate(hub, **pkginfo):
	user = "kovidgoyal"
	repo = "kitty"

	release_data = await hub.pkgtools.github.release_gen(hub, user, repo, tarball=f"{repo}-{{version}}.tar.xz")
	pkginfo.update(release_data)

	pkginfo["patches"] = pkginfo.get("patches", [])

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
#		github_user=user,
#		github_repo=repo,
	)
	ebuild.push()
