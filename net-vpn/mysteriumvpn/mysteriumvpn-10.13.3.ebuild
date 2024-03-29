# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_INSTALL_DIR="/opt/discord"

inherit desktop unpacker xdg

DESCRIPTION="Mysterium VPN is a Desktop VPN client for Windows, macOS and Linux"
HOMEPAGE="https://www.mysteriumvpn.com"
SRC_URI="https://github.com/mysteriumnetwork/mysterium-vpn-desktop/releases/download/10.13.3/mysterium-vpn-desktop_10.13.3_amd64.deb -> mysterium-vpn-desktop_10.13.3_amd64.deb"
RESTRICT="bindist"
LICENSE="MIT"
SLOT="0"
S="${WORKDIR}"

KEYWORDS="-* amd64"
IUSE=""

src_prepare() {
	default

	install -d "${S}/opt"
}

src_install() {
	domenu usr/share/applications/mysterium-vpn-desktop.desktop

	local icon_size
	for icon_size in 16 32 48 64 128 256 512; do
		pushd "${S}"/usr/share/icons/hicolor/${icon_size}x${icon_size}/apps &>/dev/null || die

		doicon -s ${icon_size} mysterium-vpn-desktop.png

		popd &>/dev/null || die
	done

	insinto /opt/MysteriumVPN
	doins -r opt/MysteriumVPN/.

	fperms +x /opt/MysteriumVPN/mysterium-vpn-desktop

	fperms 4755 /opt/MysteriumVPN/chrome-sandbox
	fperms 4755 /opt/MysteriumVPN/chrome_crashpad_handler

	dosym ../../opt/MysteriumVPN/mysterium-vpn-desktop usr/bin/mysterium-vpn-desktop

	local tools_path="/opt/MysteriumVPN/resources/app.asar.unpacked/node_modules/@mysteriumnetwork/node/bin/linux/x64"

	pushd "${S}"/"${tools_path}" &>/dev/null || die
	tools=$(find . -type f -exec printf "%s" {}"|" \;)

	local IFS_old="${IFS}"
	IFS="|"
	for tool in ${tools}; do
		fperms +x "${tools_path}"${tool#.}
	done
	IFS="${IFS_old}"

	popd
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
	xdg_desktop_database_update
}
