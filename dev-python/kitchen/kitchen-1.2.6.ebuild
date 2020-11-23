# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

SRC_URI="https://github.com/fedora-infra/${PN}/archive/${PV}.tar.gz"
KEYWORDS="*"

DESCRIPTION="Useful snippets of python code"
HOMEPAGE="https://github.com/fedora-infra/kitchen"
LICENSE="LGPL-2.1"
SLOT="0"

#S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	distutils-r1_src_prepare
}
