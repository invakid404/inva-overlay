# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A framework for managing your zsh configuration."
HOMEPAGE="https://ohmyz.sh"
SRC_URI="https://github.com/ohmyzsh/ohmyzsh/archive/2b1d4122796fea12dcaa7545cfca59fb43e6393e.tar.gz -> ohmyzsh-31032021.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

DEPEND="app-shells/zsh"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	mv ohmyzsh-* ${S} || die
}

src_prepare() {
	default
	sed -i 's/export ZSH=.*/export ZSH=\/usr\/share\/zsh\/site-contrib\/oh-my-zsh/' templates/zshrc.zsh-template
}

src_install() {
	insinto "/usr/share/zsh/site-contrib/oh-my-zsh"
	doins -r *
}

pkg_postinst() {
	elog "In order to use ${PN}, copy /usr/share/zsh/site-contrib/oh-my-zsh/templates/zshrc.zsh-template over to your ~/.zshrc"
}
