# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a bash-tool to store your private data inside a git repository"
HOMEPAGE="https://git-secret.io/"
SRC_URI="https://api.github.com/repos/sobolevn/git-secret/tarball/v0.4.0 -> git-secret-0.4.0.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="man"

DEPEND="
	app-shells/bash
	sys-apps/gawk
	dev-vcs/git
	app-crypt/gnupg
	sys-apps/coreutils
	man? ( app-text/ronn )
"
RDEPEND="${DEPEND}"

post_src_unpack() {
	mv ${WORKDIR}/sobolevn-git-secret-* ${S} || die
}

src_compile() {
	emake build
	use man && emake build-man
}

src_install() {
	emake install PREFIX="${ED}/usr"
	use man && emake install-man PREFIX="${ED}/usr"
}