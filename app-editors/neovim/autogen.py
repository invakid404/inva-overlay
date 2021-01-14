#!/usr/bin/env python3

import re


def get_release(release_data, is_stable=True):
	releases = list(filter(lambda x: x["prerelease"] != is_stable, release_data))
	return None if not releases else sorted(releases, key=lambda x: x["tag_name"]).pop()


def generate_ebuild(hub, repo_name, release_data, is_stable, **pkginfo):
	# FL-7934: Since neovim deletes the nightly release from time to time,
	# it can cause the autogen script to fail. To avoid failures and to avoid
	# forcing nightly users to downgrade to stable, a live ebuild should be
	# generated instead, that simply clones the upstream repo and builds it.
	is_live = False
	curr_release = get_release(release_data, is_stable)
	if curr_release is None:
		if is_stable:
			raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable stable release of {repo_name}")
		else:
			print(f"Nightly release of {repo_name} not found, generating a live ebuild instead.")
			is_live = True
	version = "9999"
	artifacts = []
	if not is_live:
		tag = curr_release["tag_name"]
		version = re.sub("[^0-9.]", "", curr_release["name"])
		artifacts.append(hub.pkgtools.ebuild.Artifact(
				url=f"https://github.com/{repo_name}/{repo_name}/archive/{tag}.tar.gz",
				final_name=f"{repo_name}-{version}.tar.gz"))
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		stable=is_stable,
		is_live=is_live,
		artifacts=artifacts,
	)
	ebuild.push()


async def generate(hub, **pkginfo):
	name = pkginfo["name"]
	release_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{name}/{name}/releases", is_json=True
	)

	generate_ebuild(hub, name, release_data, True, **pkginfo)
	generate_ebuild(hub, name, release_data, False, **pkginfo)
