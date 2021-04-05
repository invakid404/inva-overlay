# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=hid-${PN}

inherit linux-mod udev

DESCRIPTION="Advanced Linux Driver for Xbox One Wireless Controller (shipped with Xbox One S)"
HOMEPAGE="https://atar-axis.github.io/xpadneo"
SRC_URI="https://github.com/atar-axis/xpadneo/archive/v0.9.1.tar.gz -> xpadneo-0.9.1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

MODULE_NAMES="${MY_PN}(kernel/drivers/hid:${S}/${MY_PN}/src:${S}/${MY_PN}/src)"

src_compile() {
	BUILD_PARAMS="-C "${KV_OUT_DIR}" M=${S}/${MY_PN}/src" \
	BUILD_TARGETS="clean modules" \
		linux-mod_src_compile
}

src_prepare() {
	default

	sed -i -e \
		"s#@DO_NOT_CHANGE@#${PV}#g" \
		hid-xpadneo/src/hid-xpadneo.c || die
}

src_install() {
	linux-mod_src_install
	udev_dorules ${MY_PN}/etc-udev-rules.d/98-${PN}.rules

	echo "CONFIG_PROTECT_MASK=\"/etc/modprobe.d/98-${PN}-bluetooth.conf\"" > 50${PN}
	doenvd 50${PN}

	echo "options bluetooth disable_ertm=y" > "98-${PN}-bluetooth.conf"
	insinto /etc/modprobe.d
	doins "98-${PN}-bluetooth.conf"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	DISABLE_ERTM=/sys/module/bluetooth/parameters/disable_ertm
	if test -e "${DISABLE_ERTM}"; then
		echo "Y" > "${DISABLE_ERTM}"
	fi
}

pkg_postrm() {
	linux-mod_pkg_postinst
	udev_reload
}