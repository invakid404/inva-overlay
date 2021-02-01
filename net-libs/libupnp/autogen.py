#!/usr/bin/env python3

import re
import os
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
	repo = "pupnp"
	releases_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{repo}/{repo}/releases", is_json=True
	)
	latest_release = get_release(releases_data)
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	version = latest_release["tag_name"]
	ebuild_version = version.lstrip("release-")
	artifact_name = f"{repo}-{ebuild_version}.tar.gz"
	artifact = hub.pkgtools.ebuild.Artifact(
		url=f"https://github.com/{repo}/{repo}/archive/{version}.tar.gz",
		final_name=artifact_name,
	)
	await artifact.fetch()
	artifact.extract()
	src_dir = os.path.join(artifact.extract_path, f"{repo}-{version}")
	configure_path = os.path.join(src_dir, "configure.ac")
	slot = ""
	with open(configure_path, "r") as f:
		slot_pattern = re.compile("AC_SUBST\\(\\[LT_VERSION_UPNP\\],\s+\[(\d+):\d:\d\\]\\)")
		for line in reversed(f.readlines()):
			match = slot_pattern.match(line)
			if match is not None:
				slot = match.group(1)
				break
	slot = "0" if slot is "" else "0/" + slot
	artifact.cleanup()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=ebuild_version,
		slot=slot,
		artifacts=[artifact],
	)
	ebuild.push()
