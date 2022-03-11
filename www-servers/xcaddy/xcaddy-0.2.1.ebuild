# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!masterminds/semver/v3 v3.1.1"
	"github.com/!masterminds/semver/v3 v3.1.1/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/caddyserver/xcaddy/tarball/996c8d9d08a072c8ee7f7bd6a9b698cc395f760f -> xcaddy-0.2.1-996c8d9.tar.gz
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