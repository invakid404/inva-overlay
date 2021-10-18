# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 xdg-utils meson

DESCRIPTION="A CLI utility to control media players over MPRIS"
HOMEPAGE="https://github.com/acrisci/playerctl"
SRC_URI="https://api.github.com/repos/altdesktop/playerctl/tarball/v2.4.1 -> playerctl-2.4.1.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE="doc introspection"

RDEPEND="
	dev-libs/glib:2
	introspection? ( dev-libs/gobject-introspection:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( dev-util/gtk-doc )
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
"

post_src_unpack() {
	mv "${WORKDIR}"/altdesktop-playerctl-* "${S}" || die
}

src_configure() {
	local emesonargs=(
		-Ddatadir=share
		-Dbindir=bin
		$(meson_use doc gtk-doc)
		$(meson_use introspection)
	)

	xdg_environment_reset
	meson_src_configure
}

src_install() {
	meson_src_install

	docinto examples
	dodoc -r "${S}"/examples/.
	docompress -x "/usr/share/doc/${PF}/examples"

	newbashcomp data/playerctl.bash "${PN}"
	insinto /usr/share/zsh/site-functions
	newins data/playerctl.zsh _playerctl
}