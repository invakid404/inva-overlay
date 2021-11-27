# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit meson python-r1 xdg-utils

DESCRIPTION="GTK application to configure gaming mice"
HOMEPAGE="https://github.com/libratbag/piper"
SRC_URI="https://api.github.com/repos/libratbag/piper/tarball/refs/tags/0.6 -> piper-0.6.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-libs/libratbag:=
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-evdev[${PYTHON_USEDEP}]
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
"

post_src_unpack() {
	mv "${WORKDIR}"/libratbag-piper-* "${S}" || die
}

pkg_setup() {
	python_setup
}

src_install() {
	meson_src_install

	python_optimize
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}