# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

DESCRIPTION="FetchCord grabs your OS info and displays it as Discord Rich Presence"
HOMEPAGE="https://github.com/MrPotatoBobx/FetchCord"
SRC_URI="https://github.com/MrPotatoBobx/FetchCord/archive/v2.6.1.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/FetchCord-${PV}"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pypresence[${PYTHON_USEDEP}]
	app-misc/neofetch
	x11-apps/mesa-progs
"