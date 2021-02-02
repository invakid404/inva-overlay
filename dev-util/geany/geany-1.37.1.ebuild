# Distributed under the terms of the GNU General Public License v2

EAPI=7

# eutils required for strip-linguas
inherit eutils xdg

LANGS="ar ast be bg ca cs da de el en_GB es et eu fa fi fr gl he hi hu id ie it ja kk k ku lb lt lv mn nl nn pl pt pt_BR r ru sk sl sr sv tr uk vi zh_CN zh_TW"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="https://www.geany.org"
SRC_URI="https://github.com/geany/geany/releases/download/1.37.1/geany-1.37.1.tar.bz2 -> geany-1.37.1.tar.bz2"
KEYWORDS="*"
LICENSE="GPL-2+ HPND"
SLOT="0"

IUSE="gtk2 +vte"

BDEPEND="virtual/pkgconfig"
RDEPEND=">=dev-libs/glib-2.32:2
	gtk2? (
		>=x11-libs/gtk+-2.24:2
		vte? ( x11-libs/vte:0 )
	)
	!gtk2? (
		>=x11-libs/gtk+-3.0:3
		vte? ( x11-libs/vte:2.91 )
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	xdg_src_prepare #588570

	# Syntax highlighting for Portage
	sed -i -e "s:*.sh;:*.sh;*.ebuild;*.eclass;:" \
		data/filetype_extensions.conf || die
}

src_configure() {
	local myeconfargs=(
		--disable-html-docs
		--disable-pdf-docs
		--disable-static
		$(use_enable gtk2)
		$(use_enable vte)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}