# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tree-sitter is a parser generator tool and an incremental parsing library."
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"

SRC_URI="https://github.com/tree-sitter/tree-sitter/archive/0.17.3.tar.gz"
KEYWORDS="*"

LICENSE="MIT"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${PN}-no-static-libs.patch"
)

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="${EPREFIX}/usr/lib64" install
}