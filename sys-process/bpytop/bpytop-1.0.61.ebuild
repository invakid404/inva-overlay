# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="Linux/OSX/FreeBSD resource monitor"
HOMEPAGE="https://github.com/aristocratos/bpytop"
SRC_URI="https://files.pythonhosted.org/packages/4a/68/af63843b898c9b8a6010147ec306aab21b4d8cb684087ce9c50a94f065e7/bpytop-1.0.61.tar.gz"

DEPEND=""
RDEPEND="dev-python/psutil[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"

S="${WORKDIR}/bpytop-${PV}"

src_install() {
		insinto "/usr/share/${PN}/themes"
		doins bpytop-themes/*.theme
		distutils-r1_src_install
}
