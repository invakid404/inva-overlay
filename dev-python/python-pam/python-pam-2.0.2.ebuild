# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Python3 module for PAM authentication"
HOMEPAGE="https://github.com/FirefighterBlu3/python-pam"
SRC_URI="https://files.pythonhosted.org/packages/6a/da/879f1c849e886b783239b8a4710daac73535ba2cfcf672ee4548543e3a74/python-pam-2.0.2.tar.gz
"

DEPEND=""
RDEPEND=""

IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"

S="${WORKDIR}/python-pam-2.0.2"