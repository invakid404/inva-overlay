#!/usr/bin/env python3

from packaging import version


async def tag_generator(hub, github_user, github_repo):
	page = 1

	while True:
		current_page = await hub.pkgtools.fetch.get_page(
			f"https://api.github.com/repos/{github_user}/{github_repo}/tags?page={page}",
			is_json=True,
		)

		if not len(current_page):
			break

		yield current_page
		page += 1


async def generate(hub, **pkginfo):
	github_user = "kcat"
	github_repo = f"{pkginfo['name']}-soft"
	print(f"{github_repo}-")

	release_data = []
	async for tags_page in tag_generator(hub, github_user, github_repo):
		release_data = release_data + tags_page

	def get_version(release):
		return release["name"].lstrip(f"{github_repo}-")

	try:
		latest_release = max(
			release_data,
			key=lambda release: version.parse(get_version(release)),
		)
	except ValueError:
		raise hub.pkgtools.ebuild.BreezyError(
			f"Can't find suitable release of {github_repo}"
		)

	latest_version = get_version(latest_release)

	source_url = latest_release["tarball_url"]
	source_name = f"{github_repo}-{latest_version}.tar.gz"

	source_artifact = hub.pkgtools.ebuild.Artifact(
		url=source_url, final_name=source_name
	)

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=latest_version,
		github_user=github_user,
		github_repo=github_repo,
		artifacts=[source_artifact],
	)
	ebuild.push()
