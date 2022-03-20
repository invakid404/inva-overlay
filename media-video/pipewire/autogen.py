#!/usr/bin/env python3

from packaging import version
import re

GITLAB_URL = "https://gitlab.freedesktop.org"


async def get_latest_artifact(hub, gitlab_user, gitlab_repo):
	project_path = f"{gitlab_user}%2F{gitlab_repo}"

	tags_data = await hub.pkgtools.fetch.get_page(
		f"{GITLAB_URL}/api/v4/projects/{project_path}/repository/tags", is_json=True
	)

	latest_tag = max(
		tags_data,
		key=lambda tag: version.parse(tag["name"]),
	)

	latest_version = latest_tag["name"]

	latest_artifact = hub.pkgtools.ebuild.Artifact(
		url=f"{GITLAB_URL}/{gitlab_user}/{gitlab_repo}/-/archive/{latest_version}/{gitlab_repo}-{latest_version}.tar.gz",
		final_name=f"{gitlab_user}-{gitlab_repo}-{latest_version}-{latest_tag['commit']['id']}.tar.gz",
	)

	return dict(artifact=latest_artifact, version=latest_version)


async def generate(hub, **pkginfo):
	gitlab_user = "pipewire"

	pipewire_artifact = await get_latest_artifact(hub, gitlab_user, pkginfo["name"])
	media_session_artifact = await get_latest_artifact(
		hub, gitlab_user, "media-session"
	)

	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=pipewire_artifact["version"],
		media_session_version=media_session_artifact["version"],
		artifacts=[pipewire_artifact["artifact"], media_session_artifact["artifact"]],
	)
	ebuild.push()

