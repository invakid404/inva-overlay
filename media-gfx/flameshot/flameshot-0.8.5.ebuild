# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.js.org"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="+dbus"

FS_LINGUAS="
	ca cs de_DE es eu fr hu it_IT ja ka ko nl nl_NL pl pt_BR ru sk sr_SP sv_SE tr uk zh_CN zh_TW
"

for lingua in ${FS_LINGUAS}; do
	IUSE="${IUSE} l10n_${lingua/_/-}"
done

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtdbus:5
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
"

src_prepare() {
	default

	# QA check in case linguas are added or removed
	enum() {
		echo ${#}
	}

	[[ $(enum ${FS_LINGUAS}) -eq $(enum $(echo data/translations/*.ts)) ]] \
		|| die "Numbers of recorded and actual linguas do not match"
	unset enum

	# Delete unneeded linguas
	local lingua
	for lingua in ${FS_LINGUAS}; do
		if ! use l10n_${lingua/_/-}; then
			sed -i src/CMakeLists.txt -e "s/\${CMAKE_SOURCE_DIR}\/data\/translations\/Internationalization_${lingua}\.ts//g" || die
			rm data/translations/Internationalization_${lingua}.ts || die
		fi
	done

	cmake_src_prepare
}

pkg_postinst(){
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm(){
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
