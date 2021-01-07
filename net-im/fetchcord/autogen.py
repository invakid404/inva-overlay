#!/usr/bin/env python3


def get_release(releases_data):
	latest_version = releases_data["info"]["version"]
	return latest_version, next(
		(x for x in releases_data["releases"][latest_version] if x["packagetype"] == "sdist"),
		None,
	)


async def generate(hub, **pkginfo):
	name = pkginfo["name"]
	repo = "FetchCord"
	releases_data = await hub.pkgtools.fetch.get_page(
		f"https://pypi.org/pypi/{repo}/json", is_json=True
	)
	version, latest_source = get_release(releases_data)
	if latest_source is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		repo_user="MrPotatoBobx",
		repo_name=repo,
		artifacts=[
			hub.pkgtools.ebuild.Artifact(
				url=latest_source["url"], final_name=f"{name}-{version}.tar.gz"
			)
		],
	)
	ebuild.push()
