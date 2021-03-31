# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fish-like fast/unobtrusive autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions/"
SRC_URI="https://github.com/zsh-users/${PN}/archive/ae315ded4dba10685dbbafbfa2ff3c1aefeb490d.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
RESTRICT="primaryuri test"

IUSE="ohmyzsh"

RDEPEND="app-shells/zsh"

DOCS=(
	CHANGELOG.md
	README.md
)

src_unpack() {
	default
	mv ${PN}-* ${S} || die
}

src_prepare() {
	default

	emake clean
}

src_install() {
	einstalldocs

	export INSTALL_DIR="/usr/share/zsh/plugins/${PN}"

	insinto "${INSTALL_DIR}"
	doins "${PN}.zsh"

	use ohmyzsh && \
		insinto "${INSTALL_DIR}"
		doins "${PN}.plugin.zsh"
		dosym ${INSTALL_DIR} /usr/share/zsh/site-contrib/oh-my-zsh/custom/plugins/${PN}
}

pkg_postinst() {
	einfo "For use this script, load it into your interactive ZSH session:"
	einfo "\tsource /usr/share/zsh/plugins/${PN}/${PN}.zsh"
	einfo
	einfo "For further information, please read the README.md file installed"
	einfo "in /usr/share/doc/${PF}"
}
