# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="ssl"

DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="A mail retriever with reliable Maildir and mbox delivery"
HOMEPAGE="https://www.getmail6.org/ https://github.com/getmail6/getmail6"
SRC_URI="https://api.github.com/repos/getmail6/getmail6/tarball/v6.18.3 -> getmail6-6.18.3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/getmail6-getmail6-* ${S} || die
}

python_prepare_all() {
	# Use gentoo version number (including revision) for doc dir and remove COPYING file
	sed -i -e "s,'getmail-%s' % __version__,'${PF}'," \
		-e "/docs\/COPYING/d" "${S}"/setup.py || die

	distutils-r1_python_prepare_all
}