#!/usr/bin/env python3

import re
from datetime import datetime


def get_release(release_data, is_stable=True):
	releases = list(filter(lambda x: x["prerelease"] != is_stable, release_data))
	return None if not releases else sorted(releases, key=lambda x: x["tag_name"]).pop()


async def generate_ebuild(hub, repo_name, release_data, is_stable, **pkginfo):
	# FL-7934: Since neovim deletes the nightly release from time to time,
	# it can cause the autogen script to fail. To avoid failures and to avoid
	# forcing nightly users to downgrade to stable, a live ebuild should be
	# generated instead, that simply clones the upstream repo and builds it.
	curr_release = get_release(release_data, is_stable)
	commit_sha = ""
	if curr_release is None:
		if is_stable:
			raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable stable release of {repo_name}")
		else:
			print(f"Nightly release of {repo_name} not found, generating a snapshot ebuild instead.")
			commit_sha = await hub.pkgtools.fetch.get_page(
				f"https://api.github.com/repos/{repo_name}/{repo_name}/commits/master", is_json=True
			)["sha"]

	version = ""
	src_name = ""
	if commit_sha:
		src_name = commit_sha
		version = datetime.now().strftime("%Y%d%m")
	else:
		src_name = curr_release["tag_name"]
		version = re.sub("[^0-9.]", "", curr_release["name"])

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		stable=is_stable,
		artifacts=[
			hub.pkgtools.ebuild.Artifact(
				url=f"https://github.com/{repo_name}/{repo_name}/archive/{src_name}.tar.gz",
				final_name=f"{repo_name}-{version}.tar.gz",
			)
		],
	)
	ebuild.push()


async def generate(hub, **pkginfo):
	name = pkginfo["name"]
	release_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{name}/{name}/releases", is_json=True
	)

	await generate_ebuild(hub, name, release_data, True, **pkginfo)
	await generate_ebuild(hub, name, release_data, False, **pkginfo)
