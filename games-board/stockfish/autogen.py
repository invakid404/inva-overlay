#!/usr/bin/env python3

from packaging import version
from bs4 import BeautifulSoup
import urllib.parse
import glob
import os
import re


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
	nn_base_url = "https://tests.stockfishchess.org/api/nn/"
	nn_pattern = re.compile("nn-[a-z0-9]{12}.nnue")
	user = "official-stockfish"
	repo = "Stockfish"
	release_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/releases", is_json=True
	)
	latest_release = get_release(release_data)
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	version = latest_release["tag_name"].lstrip("sf_")
	url = latest_release["tarball_url"]
	final_name = f"{repo}-{version}.tar.gz"
	src_artifact = hub.pkgtools.ebuild.Artifact(url=url, final_name=final_name)
	await src_artifact.fetch()
	src_artifact.extract()
	evaluate_path = glob.glob(
		os.path.join(src_artifact.extract_path, "*/src/evaluate.h")
	)[0]
	with open(evaluate_path, "r") as f:
		lines = f.readlines()
	nn_matches = (nn_pattern.search(x) for x in lines)
	nn_file = next((x.group(0) for x in nn_matches if x))
	nn_artifact = hub.pkgtools.ebuild.Artifact(
		url=urllib.parse.urljoin(nn_base_url, nn_file)
	)
	src_artifact.cleanup()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=version,
		github_user=user,
		github_repo=repo,
		nn_name=nn_file,
		artifacts=[src_artifact, nn_artifact],
	)
	ebuild.push()
