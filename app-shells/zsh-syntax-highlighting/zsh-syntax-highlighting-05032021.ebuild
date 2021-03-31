# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/zsh-users/${PN}/archive/e8517244f7d2ae4f9d979faf94608d6e4a74a73e.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

DESCRIPTION="Fish shell-like syntax highlighting for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"

LICENSE="BSD"
SLOT="0"

IUSE="ohmyzsh"

RDEPEND="
	app-shells/zsh
	ohmyzsh? ( app-shells/ohmyzsh )"

DISABLE_AUTOFORMATTING="true"

src_unpack() {
	default
	mv ${PN}-* ${S} || die
}

src_install() {
	export INSTALL_DIR="/usr/share/zsh/plugins/${PN}"

	emake \
		SHARE_DIR="${ED}${INSTALL_DIR}" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install

	use ohmyzsh && \
		insinto "${INSTALL_DIR}"
		doins "${PN}.plugin.zsh"
		dosym ${INSTALL_DIR} /usr/share/zsh/site-contrib/oh-my-zsh/custom/plugins/${PN}
}
