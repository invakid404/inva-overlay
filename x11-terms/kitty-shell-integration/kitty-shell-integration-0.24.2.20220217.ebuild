# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Shell integration scripts for kitty, a GPU-based terminal emulator"
HOMEPAGE="https://sw.kovidgoyal.net/kitty/"
SRC_URI="https://github.com/kovidgoyal/kitty/archive/cfd0872cea4b840c5cc3dbe8d72f04b3ec43f644.tar.gz"
S="${WORKDIR}/kitty-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
RESTRICT="test" # intended to be ran on the full kitty package

PATCHES=(
)

src_unpack() {
	unpack ${A}
	rm -rf ${S}
	mv ${WORKDIR}/kitty-* ${S} || die
}

src_compile() { :; }

src_install() {
	# install the whole directory in the upstream suggested location
	# for consistency (i.e. less variation between distros if someone
	# ssh into Gentoo), then set symlinks to autoload where possible
	# (these exit immediately if KITTY_SHELL_INTEGRATION is unset)
	insinto /usr/share/kitty
	doins -r shell-integration

	dosym {/usr/share/kitty/shell-integration/bash,/etc/bash/bashrc.d}/kitty.bash

	dosym /usr/share/{kitty/shell-integration/fish,fish}/vendor_completions.d/kitty.fish
	dosym /usr/share/{kitty/shell-integration/fish,fish}/vendor_conf.d/kitty-shell-integration.fish

	dosym /usr/share/{kitty/shell-integration/zsh/completions,zsh/site-functions}/_kitty
	# zsh integration is handled automatically without needing to modify rc files,
	# but may require user intervention depending on zsh invocation or if remote
}