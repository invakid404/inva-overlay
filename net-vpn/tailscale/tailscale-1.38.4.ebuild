# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
VERSION_SHORT="1.38.4"
VERSION_LONG="1.38.4-t043a34500"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/043a34500dd2bb07c34e3b28a56cdbc8b5434454 -> tailscale-1.38.4-043a345.tar.gz https://direct.funtoo.org/15/43/e7/1543e7326eac8450a84e9db93ce8708887e10d8ad85d6335cf758eab0e1ae524ec02c3fbc24768e63bbfef7bd033145c925d9221997209acee957660a44849f9 -> tailscale-1.38.4-funtoo-go-bundle-53ba5b255e2c1a6bba1607eb10cc5b752b16713f9ca2384989d0b07015f4ba0890442c8c98e8c94d3bf7c93fc99ff0df644765ca0e8e9a45135ad00071fcc27e.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

RDEPEND="net-firewall/iptables"

post_src_unpack() {
    mv "${WORKDIR}"/tailscale-tailscale-* "${S}" || die
}

# This translates the build command from upstream's build_dist.sh to an
# ebuild equivalent.
build_dist() {
	go build -tags xversion -ldflags "
		-X tailscale.com/version.longStamp=${VERSION_LONG}
		-X tailscale.com/version.shortStamp=${VERSION_SHORT}" "$@"
}

src_compile() {
	build_dist ./cmd/tailscale
	build_dist ./cmd/tailscaled
}

src_install() {
	dosbin tailscaled
	dobin tailscale

	insinto /etc/default
	newins cmd/tailscaled/tailscaled.defaults tailscaled
	keepdir /var/lib/${PN}
	fperms 0750 /var/lib/${PN}

	newtmpfiles "${FILESDIR}/${PN}.tmpfiles" ${PN}.conf

	newinitd "${FILESDIR}/${PN}d.initd" ${PN}
	newconfd "${FILESDIR}/${PN}d.confd" ${PN}
}

pkg_postinst() {
	tmpfiles_process ${PN}.conf
}