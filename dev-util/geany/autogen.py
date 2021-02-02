#!/usr/bin/env python3

import re
import os
from pathlib import Path
from packaging import version


def get_release(releases_data):
	releases = list(
		filter(lambda x: x["prerelease"] is False and x["draft"] is False, releases_data)
	)
	return (
		None
		if not releases
		else sorted(releases, key=lambda x: version.parse(x["tag_name"])).pop()
	)


async def generate(hub, **pkginfo):
	user = repo = pkginfo["name"]
	releases_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/releases", is_json=True
	)
	latest_release = get_release(releases_data)
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	version = latest_release["tag_name"]
	artifact_name = f"{repo}-{version}.tar.bz2"
	artifact = hub.pkgtools.ebuild.Artifact(
		url=f"https://github.com/{user}/{repo}/releases/download/{version}/{artifact_name}",
		final_name=artifact_name,
	)
	await artifact.fetch()
	artifact.extract()
	print(artifact.extract_path)
	extract_path = Path(artifact.extract_path)
	src_path = next(extract_path.iterdir())
	translations = " ".join([i.name.rstrip(".po") for i in src_path.joinpath("po").glob("*.po")])
	artifact.cleanup()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		translations=translations,
		artifacts=[artifact],
	)
	ebuild.push()
