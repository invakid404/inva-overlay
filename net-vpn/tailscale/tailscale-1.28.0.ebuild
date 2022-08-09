# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module tmpfiles

# These settings are obtained by running ./build_dist.sh shellvars` in
# the upstream repo.
VERSION_MINOR="1.28"
VERSION_SHORT="1.28.0"
VERSION_LONG="1.28.0-taabca3a4"
VERSION_GIT_HASH="aabca3a4c431d24199c1deb25d4684516ead88ca"

DESCRIPTION="Tailscale vpn client"
HOMEPAGE="https://tailscale.com"
SRC_URI="https://github.com/tailscale/tailscale/tarball/aabca3a4c431d24199c1deb25d4684516ead88ca -> tailscale-1.28.0-aabca3a.tar.gz https://direct.funtoo.org/04/9f/7e/049f7e29a98f71d4f7ef66f7ec1deb8e8a4f65bdd4d806c4cf1abee45d4bafd7cc0af774d2bf89212b9ef3ee61d04e684dca6bc549edbf0e07b831f4a08a76c3 -> tailscale-1.28.0-go-deps.tar.xz"

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
		-X tailscale.com/version.Long=${VERSION_LONG}
		-X tailscale.com/version.Short=${VERSION_SHORT}
		-X tailscale.com/version.GitCommit=${VERSION_GIT_HASH}" "$@"
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