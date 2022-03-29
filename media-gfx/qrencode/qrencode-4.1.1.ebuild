# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C library for encoding data in a QR Code symbol"
HOMEPAGE="https://fukuchi.org/works/qrencode/"
SRC_URI="https://fukuchi.org/works/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0/4"
KEYWORDS="*"
IUSE="png"

RDEPEND="
	png? ( media-libs/libpng:0= )
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local myconf=(
		$(use_with png)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
