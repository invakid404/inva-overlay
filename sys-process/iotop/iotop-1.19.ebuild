# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps

DESCRIPTION="Interactive monitor of Linux IO activity"
HOMEPAGE="https://github.com/Tomas-M/iotop"
SRC_URI="https://github.com/Tomas-M/iotop/releases/download/v1.19/iotop-1.19.tar.xz"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="*"
IUSE="+caps"

DEPEND="
	sys-libs/ncurses
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	emake install DESTDIR="${D}" STRIP="true"
}

pkg_postinst() {
	use caps && fcaps cap_net_admin=eip /usr/sbin/iotop
}