#!/usr/bin/env python3

import re
import os
from pathlib import Path
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
	# Plugins that should never be enabled at all
	disabled_plugins = {
		"geanygendoc",
		"devhelp",
		"webhelper",
		"geanypy",
		"multiterm",
		"geanydoc",
		"updatechecker",
	}
	# Plugins that require additional deps
	# Should also be disabled by default
	additional_deps = {
		"debugger": "x11-libs/vte:2.91",
		"geanyctags": "dev-util/ctags",
		"geanylua": "dev-lang/lua:0=",
		"geanypg": "app-crypt/gpgme:1=",
		"geniuspaste": "net-libs/libsoup:2.4",
		"gitchangebar": "dev-libs/libgit2:=",
		"markdown": "app-text/discount\nnet-libs/webkit-gtk:4",
		"pretty-printer": "dev-libs/libxml2:2",
		"scope": "x11-libs/vte:2.91\nsys-devel/gdb",
		"spellcheck": "app-text/enchant:=",
		"workbench": "dev-libs/libgit2:=",
	}
	user = "geany"
	repo = pkginfo["name"]
	releases_data = await hub.pkgtools.fetch.get_page(
		f"https://api.github.com/repos/{user}/{repo}/releases", is_json=True
	)
	latest_release = get_release(releases_data)
	if latest_release is None:
		raise hub.pkgtools.ebuild.BreezyError(f"Can't find a suitable release of {repo}")
	version = latest_release["tag_name"]
	artifact_name = f"{repo}-{version}.tar.gz"
	artifact = hub.pkgtools.ebuild.Artifact(
		url=f"https://github.com/{user}/{repo}/archive/{version}.tar.gz",
		final_name=artifact_name,
	)
	await artifact.fetch()
	artifact.extract()
	extract_path = Path(artifact.extract_path)
	src_path = next(extract_path.iterdir())
	plugin_regex = re.compile("if ENABLE_(.*)")
	with open(src_path.joinpath("Makefile.am"), "r") as f:
		makefile_lines = f.readlines()
		plugin_matches = [plugin_regex.match(i) for i in makefile_lines]
		plugins = [i.group(1) for i in plugin_matches if i]
	plugins = [i.replace("_", "-").lower().strip() for i in plugins]
	print(plugins)
	use_flags = " ".join([f"{'' if i in additional_deps else '+'}{i}" for i in plugins if i not in disabled_plugins])
	use_deps = "\n".join([f"{i}? ( {j} )" for i, j in additional_deps.items()])
	config_flags = "\n".join([f"--disable-{i}" if i in disabled_plugins else f"$(use_enable {i})" for i in plugins])
	print(config_flags)
	artifact.cleanup()
	ebuild = hub.pkgtools.ebuild.BreezyBuild(
		**pkginfo, version=version, use_flags=use_flags, use_deps=use_deps, config_flags=config_flags, artifacts=[artifact]
	)
	ebuild.push()
