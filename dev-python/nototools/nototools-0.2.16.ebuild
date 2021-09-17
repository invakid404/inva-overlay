# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlefonts/nototools"
SRC_URI="https://files.pythonhosted.org/packages/0f/46/07752d7ffbb9e3ca3b83518568eee91e4f1e1dbd0e39f7ad9fd59461eadb/notofonttools-0.2.16.tar.gz
"

DEPEND=""
RDEPEND="
	media-gfx/scour
	dev-python/booleanOperations[${PYTHON_USEDEP}]
	dev-python/defcon[${PYTHON_USEDEP}]
	dev-python/fonttools[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyclipper[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="Apache-2.0 OFL-1.1"
KEYWORDS="*"

S="${WORKDIR}/notofonttools-0.2.16"