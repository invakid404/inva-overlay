#!/usr/bin/env python3


async def generate(hub, **pkginfo):
	user = "NixOS"
	repo = pkginfo["name"]
	tag_data = await hub.pkgtools.fetch.get_page(f"https://api.github.com/repos/{user}/{repo}/tags", is_json=True)
	target_tag = tag_data[0]
	version = target_tag["name"]
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		artifacts=[hub.pkgtools.ebuild.Artifact(url=f"http://nixos.org/releases/{repo}/{repo}-{version}/{repo}-{version}.tar.xz")],
	)
	ebuild.push()
