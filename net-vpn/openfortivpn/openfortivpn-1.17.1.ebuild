# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info

DESCRIPTION="Fortinet compatible VPN client"
HOMEPAGE="https://github.com/adrienverge/openfortivpn"
SRC_URI="https://api.github.com/repos/adrienverge/openfortivpn/tarball/refs/tags/v1.17.1 -> openfortivpn-1.17.1.tar.gz"

LICENSE="GPL-3-with-openssl-exception openssl"
SLOT="0"
KEYWORDS="*"

DEPEND="
	net-dialup/ppp
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~PPP ~PPP_ASYNC"

post_src_unpack() {
	mv "${WORKDIR}"/adrienverge-openfortivpn-* "${S}" || die
}

src_prepare() {
	default

	sed -i 's/-Werror//g' Makefile.am || die "Failed to remove -Werror from Makefile.am"

	eautoreconf
}

src_install() {
	default

	keepdir /etc/openfortivpn
}