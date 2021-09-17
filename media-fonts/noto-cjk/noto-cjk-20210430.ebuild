# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Google's CJK font family"
HOMEPAGE="https://www.google.com/get/noto/ https://github.com/googlei18n/noto-cjk"
SRC_URI="https://github.com/googlei18n/noto-cjk/archive/cee7438f5f8e66397090d483c15275d1af3d87c7.tar.gz -> noto-cjk-20210430-cee7438f5f8e66397090d483c15275d1af3d87c7.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="*"
IUSE=""

RESTRICT="binchecks strip"

FILESDIR="${REPODIR}/media-fonts/noto-gen/files"

FONT_CONF=( "${FILESDIR}/70-noto-cjk.conf" ) # From ArchLinux
FONT_SUFFIX="ttc"

post_src_unpack() {
	mv ${WORKDIR}/noto-cjk-* ${S} || die
}