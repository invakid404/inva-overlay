# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Powerful yet simple to use screenshot software"
HOMEPAGE="https://flameshot.js.org"
SRC_URI="https://github.com/flameshot-org/flameshot/archive/v0.10.1.tar.gz -> flameshot-v0.10.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="+dbus"

FS_LINGUAS="
	ca cs de_DE el es eu fr gl he hu id it_IT ja ka ko nb_NO nl nl_NL pl pt_BR ru sk sr_SP sv_SE tr uk zh_CN zh_HK zh_TW
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
	dev-qt/qtsingleapplication[qt5(+),X]
	dev-libs/spdlog
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
"


src_prepare() {
	default

	rm -r external/spdlog || die
	rm -r external/singleapplication || die

	# QA check in case linguas are added or removed
	enum() {
		echo "${#}"
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

src_configure() {
	local mycmakeargs=(
		-DUSE_EXTERNAL_SPDLOG=1
		-DUSE_EXTERNAL_SINGLEAPPLICATION=1
		-DENABLE_CACHE=0
	)

	cmake_src_configure
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
