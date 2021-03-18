# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/Masterminds/semver/v3 v3.1.0"
	"github.com/Masterminds/semver/v3 v3.1.0/go.mod"
)

go-module_set_globals

SRC_URI="https://api.github.com/repos/caddyserver/xcaddy/tarball/v0.1.8 -> xcaddy-v0.1.8.tar.gz
	${EGO_SUM_SRC_URI}"

DESCRIPTION="Custom Caddy Builder"
HOMEPAGE="https://github.com/caddyserver/xcaddy"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

src_unpack() {
	go-module_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/caddyserver-xcaddy-* ${S} || die
}

src_compile() {
	go build -mod=mod ./cmd/xcaddy || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}