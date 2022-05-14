# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!masterminds/semver/v3 v3.1.1"
	"github.com/!masterminds/semver/v3 v3.1.1/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/caddyserver/xcaddy/tarball/71ce25d1a2d50478be443aba1eee8e854ea2ba32 -> xcaddy-0.3.0-71ce25d.tar.gz
	${EGO_SUM_SRC_URI}"

DESCRIPTION="Custom Caddy Builder"
HOMEPAGE="https://github.com/caddyserver/xcaddy"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

post_src_unpack() {
	mv "${WORKDIR}"/caddyserver-xcaddy-* "${S}" || die
}

src_unpack() {
	go-module_src_unpack
}

src_compile() {
	go build -mod=mod ./cmd/xcaddy || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}