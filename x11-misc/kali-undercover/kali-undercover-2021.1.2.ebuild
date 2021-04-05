# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="Kali Undercover is a set of scripts that changes the look and feel of your Xfce Linux desktop environment to Windows 10 desktop environment"
HOMEPAGE="https://gitlab.com/kalilinux/packages/kali-undercover"
SRC_URI="https://gitlab.com/kalilinux/packages/kali-undercover/-/archive/kali/2021.1.2/kali-undercover-kali-2021.1.2.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="*"
IUSE="+shell"

DEPEND="
	media-fonts/liberation-fonts
	x11-libs/libnotify
	sys-process/procps
	sys-process/psmisc
	xfce-extra/xfce4-power-manager
	xfce-extra/xfce4-pulseaudio-plugin
	xfce-extra/xfce4-whiskermenu-plugin
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mv ${PN}-* ${S} || die
}

src_prepare() {
	default
	use shell || sed -i '/.bashrc/d; /.zshrc/d' bin/kali-undercover
}

src_install() {
	insinto /usr/share
	doins -r share/*

	insinto /usr/bin
	doins bin/kali-undercover

	fperms +x /usr/bin/kali-undercover
	fperms +x /usr/share/kali-undercover/scripts/*
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
