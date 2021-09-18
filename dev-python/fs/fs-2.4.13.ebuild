# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Filesystem abstraction layer"
HOMEPAGE="https://pypi.org/project/fs/ https://docs.pyfilesystem.org https://www.willmcgugan.com/tag/fs/"
SRC_URI="https://files.pythonhosted.org/packages/15/e4/0b9d0647dd1953e5d934a9b889f745867afafdfbf4b8439f73b864e3d7e2/fs-2.4.13.tar.gz
"

DEPEND=""
RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"

S="${WORKDIR}/fs-2.4.13"

pkg_postinst() {
	echo "S3 support dev-python/boto"
	echo "SFTP support dev-python/paramiko"
	echo "Browser support dev-python/wxpython"
}
