# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="NCurses Disk Usage"
HOMEPAGE="https://dev.yorhel.nl/ncdu/"
SRC_URI="https://dev.yorhel.nl/download/ncdu-2.1.2.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/pkgconfig"

DEPEND="sys-libs/ncurses:=[unicode(+)]"
BDEPEND="dev-lang/zig-bin"

RDEPEND="${DEPEND}"

src_install() {
	emake PREFIX="${ED}"/usr install
}