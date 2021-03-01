#!/usr/bin/env python3

from packaging import version
from bs4 import BeautifulSoup
import urllib.parse
import re


async def generate(hub, **pkginfo):
	name = pkginfo["name"]
	download_url = "https://www.wireshark.org/download/src/all-versions/"
	download_data = await hub.pkgtools.fetch.get_page(download_url)
	download_soup = BeautifulSoup(download_data, "html.parser")
	name_pattern = re.compile(f"({name}-(.*)\\.tar\\..*)")
	matches = [
		name_pattern.match(link["href"]) for link in download_soup.find_all("a", href=True)
	]
	releases = sorted(
		(x.groups() for x in matches if x), key=lambda x: version.parse(x[1])
	)
	filename, latest_version = releases.pop()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo,
		version=latest_version,
		artifacts=[
			hub.pkgtools.ebuild.Artifact(url=urllib.parse.urljoin(download_url, filename))
		],
	)
	ebuild.push()
