#!/usr/bin/env python3

import json
import urllib.parse


async def generate(hub, **pkginfo):
	gitlab_user = "ajak"
	gitlab_repo = pkginfo["name"]
	project_path = urllib.parse.quote_plus(f"{gitlab_user}/{gitlab_repo}")
	tags_data = await hub.pkgtools.fetch.get_page(f"https://gitlab.com/api/v4/projects/{project_path}/repository/tags")
	tags_dict = json.loads(tags_data)
	latest_version = tags_dict[0]["name"]
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=latest_version.lstrip("v"),
		artifacts=[
			hub.pkgtools.ebuild.Artifact(
				url=f"https://gitlab.com/{gitlab_user}/{gitlab_repo}/-/archive/{latest_version}/{gitlab_repo}-{latest_version}.tar.gz"
			)
		]
	)
	ebuild.push()

# vim: ts=4 sw=4 noet
