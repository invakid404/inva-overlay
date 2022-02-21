#!/usr/bin/env python3
from datetime import datetime, timedelta
from packaging import version


async def query_github_api(user, repo, query):
	return await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/{query}",
		is_json=True,
		refresh_interval=timedelta(days=15),
	)


def get_release(release_data):
	releases = list(filter(lambda x: x["prerelease"] is False and x["draft"] is False, release_data))
	return None if not releases else sorted(releases, key=lambda x: version.parse(x["tag_name"])).pop()


async def is_commit_safe(user, repo, commit):
	commit_status = await query_github_api(user, repo, f"commits/{commit}/status")
	return "failure" not in commit_status["state"]


async def generate(hub, **pkginfo):
	user = "kovidgoyal"
	repo = "kitty"
	releases_data = await query_github_api(user, repo, "releases")
	latest_release = get_release(releases_data)
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	tag_version = latest_release["tag_name"]
	version = tag_version.lstrip("v")
	pkginfo["patches"] = pkginfo.get("patches", [])
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		tag_version=tag_version,
		github_user=user,
		github_repo=repo,
		artifacts=[
			hub.pkgtools.ebuild.Artifact(url=latest_release["tarball_url"], final_name=f"{repo}-{version}.tar.gz"),
			hub.pkgtools.ebuild.Artifact(
				url=f"https://github.com/{user}/{repo}/releases/download/{tag_version}/{repo}-{version}.tar.xz"
			),
		],
	)
	ebuild.push()
