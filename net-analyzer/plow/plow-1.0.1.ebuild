# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/AdhityaRamadhanus/fasthttpcors v0.0.0-20170121111917-d4c07198763a"
	"github.com/AdhityaRamadhanus/fasthttpcors v0.0.0-20170121111917-d4c07198763a/go.mod"
	"github.com/BurntSushi/toml v0.3.1"
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/alecthomas/units v0.0.0-20210208195552-ff826a37aa15"
	"github.com/alecthomas/units v0.0.0-20210208195552-ff826a37aa15/go.mod"
	"github.com/andybalholm/brotli v1.0.2/go.mod"
	"github.com/andybalholm/brotli v1.0.3"
	"github.com/andybalholm/brotli v1.0.3/go.mod"
	"github.com/beorn7/perks v1.0.1"
	"github.com/beorn7/perks v1.0.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/go-echarts/go-echarts/v2 v2.2.4"
	"github.com/go-echarts/go-echarts/v2 v2.2.4/go.mod"
	"github.com/golang/snappy v0.0.3/go.mod"
	"github.com/klauspost/compress v1.12.2/go.mod"
	"github.com/klauspost/compress v1.13.0"
	"github.com/klauspost/compress v1.13.0/go.mod"
	"github.com/kr/pretty v0.1.0"
	"github.com/kr/pretty v0.1.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/mattn/go-isatty v0.0.13"
	"github.com/mattn/go-isatty v0.0.13/go.mod"
	"github.com/mattn/go-runewidth v0.0.13"
	"github.com/mattn/go-runewidth v0.0.13/go.mod"
	"github.com/nicksnyder/go-i18n v1.10.1"
	"github.com/nicksnyder/go-i18n v1.10.1/go.mod"
	"github.com/pelletier/go-toml v1.2.0"
	"github.com/pelletier/go-toml v1.2.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/uniseg v0.2.0"
	"github.com/rivo/uniseg v0.2.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.6.0"
	"github.com/stretchr/testify v1.6.0/go.mod"
	"github.com/valyala/bytebufferpool v1.0.0"
	"github.com/valyala/bytebufferpool v1.0.0/go.mod"
	"github.com/valyala/fasthttp v1.27.0"
	"github.com/valyala/fasthttp v1.27.0/go.mod"
	"github.com/valyala/tcplisten v1.0.0/go.mod"
	"go.uber.org/automaxprocs v1.4.0"
	"go.uber.org/automaxprocs v1.4.0/go.mod"
	"golang.org/x/crypto v0.0.0-20210513164829-c07d793c2f9a/go.mod"
	"golang.org/x/net v0.0.0-20210226172049-e18ecbb05110/go.mod"
	"golang.org/x/net v0.0.0-20210510120150-4163338589ed/go.mod"
	"golang.org/x/net v0.0.0-20210525063256-abc453219eb5"
	"golang.org/x/net v0.0.0-20210525063256-abc453219eb5/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/sys v0.0.0-20210514084401-e8d321eab015"
	"golang.org/x/sys v0.0.0-20210514084401-e8d321eab015/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/text v0.3.3/go.mod"
	"golang.org/x/text v0.3.6"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/alecthomas/kingpin.v3-unstable v3.0.0-20191105091915-95d230a53780"
	"gopkg.in/alecthomas/kingpin.v3-unstable v3.0.0-20191105091915-95d230a53780/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
	"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
	"gopkg.in/yaml.v2 v2.2.1/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.4.0"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)

go-module_set_globals

DESCRIPTION="HTTP(S) benchmarking tool, written in Golang"
HOMEPAGE="https://github.com/six-ddc/plow"
SRC_URI="https://api.github.com/repos/six-ddc/plow/tarball/v1.0.1 -> plow-1.0.1.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

src_unpack() {
	go-module_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/six-ddc-plow-* ${S} || die
}

src_compile() {
	go build -mod=mod . || die "compile failed"
}

src_install() {
	dobin ${PN}
	dodoc README.md
}