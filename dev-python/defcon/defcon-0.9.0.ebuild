# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="A set of UFO based objects for use in font editing applications"
HOMEPAGE="https://github.com/robotools/defcon"
SRC_URI="https://files.pythonhosted.org/packages/31/94/f9c0112cc40c89d6d224a6aa61c1999ba8e17ef9f2bafdfb574a198a59f3/defcon-0.9.0.zip
"

DEPEND="dev-python/fonttools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"

S="${WORKDIR}/defcon-0.9.0"