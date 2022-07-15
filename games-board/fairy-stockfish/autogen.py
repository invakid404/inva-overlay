#!/usr/bin/env python3

import re


async def generate(hub, **pkginfo):
	github_user = "ianfab"
	github_repo = "Fairy-Stockfish"

	tag_name_pattern = re.compile("^fairy_sf_([\\d_]+)")

	def transform_tag_name(tag_name):
		tag_name_match = tag_name_pattern.match(tag_name)
		if not tag_name_match:
			return tag_name

		(version,) = tag_name_match.groups()

		return version.rstrip("_").replace("_", ".")

	release_info = await hub.pkgtools.github.release_gen(
		hub, github_user, github_repo, transform=transform_tag_name
	)
	pkginfo.update(release_info)

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		github_user=github_user,
		github_repo=github_repo,
	)
	ebuild.push()

