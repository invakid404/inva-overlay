# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A set of tools to manage bluetooth devices for linux"
HOMEPAGE="https://github.com/khvzak/bluez-tools"
SRC_URI="https://github.com/khvzak/bluez-tools/archive/f65321736475429316f07ee94ec0deac8e46ec4a.tar.gz -> bluez-tools-20201025.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	net-wireless/bluez[obex]
	sys-libs/readline:0
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS README )

post_src_unpack() {
	mv "${WORKDIR}"/bluez-tools-f65321736475429316f07ee94ec0deac8e46ec4a "${S}" || die
}

src_prepare() {
	default

	eautoreconf
}