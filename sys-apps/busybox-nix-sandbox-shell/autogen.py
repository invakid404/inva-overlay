#!/usr/bin/env python3

from bs4 import BeautifulSoup
from packaging import version
import re


async def generate(hub, **pkginfo):
    base_url = "https://busybox.net/downloads"
    base_data = await hub.pkgtools.fetch.get_page(base_url)
    base_soup = BeautifulSoup(base_data, "lxml")
    name_pattern = re.compile("^(busybox-(.+).tar.bz2)$")
    file_matches = (name_pattern.match(i.get("href")) for i in base_soup.find_all("a", href=True))
    sorted_files = sorted((x for x in file_matches if x), key=lambda x: version.parse(x.group(1)), reverse=True)
    target_file, target_version = next(x.groups() for x in sorted_files)
    source_artifact = hub.pkgtools.ebuild.Artifact(url=f"{base_url}/{target_file}")
    ebuild = hub.pkgtools.ebuild.BreezyBuild(
        **pkginfo,
        version=target_version,
        artifacts=[source_artifact],
    )
    ebuild.push()
