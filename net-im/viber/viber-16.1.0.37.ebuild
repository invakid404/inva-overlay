# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils unpacker xdg

DESCRIPTION="Free text and calls"
HOMEPAGE="https://www.viber.com/en/"
SRC_URI="https://download.cdn.viber.com/cdn/desktop/Linux/${PN}.deb -> ${P}.deb"

LICENSE="viber"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="apulse +pulseaudio"
REQUIRED_USE="^^ ( apulse pulseaudio )"
RESTRICT="bindist mirror"

RDEPEND="dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-libs/openssl-compat
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb:0/1.12
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
	x11-libs/xcb-util-wm
	apulse? ( media-sound/apulse )
	pulseaudio? (
		media-sound/pulseaudio
		media-plugins/gst-plugins-pulse )"
BDEPEND="sys-apps/fix-gnustack"

S="${WORKDIR}"

QA_PREBUILT="/opt/viber/Viber
	/opt/viber/libexec/QtWebEngineProcess
	/opt/viber/plugins/*/*.so
	/opt/viber/lib/*
	/opt/viber/qml/*"

src_prepare() {
	default

	if use apulse ; then
		sed -i '/Exec=/s|/opt|apulse /opt|' \
			usr/share/applications/viber.desktop || die "sed failed"
	fi

	# remove hardcoded path
	sed -i '/Icon/s|/usr/share/pixmaps/viber.png|viber|' \
		usr/share/applications/viber.desktop \
		|| die "sed failed for viber.desktop"
}

src_install() {
	fix-gnustack -f opt/viber/lib/libQt5WebEngineCore.so.5 > /dev/null \
		|| die "removing execstack flag failed"

	newicon -s scalable usr/share/icons/hicolor/scalable/apps/Viber.svg \
		viber.svg
	for size in 16x16 24x24 32x32 48x48 64x64 96x96 128x128 256x256; do
		newicon -s "${size%%x*}" usr/share/viber/"${size}".png viber.png
	done
	dosym ../icons/hicolor/96x96/apps/viber.png \
		/usr/share/pixmaps/viber.png

	domenu usr/share/applications/viber.desktop

	insinto /opt/viber
	doins -r opt/viber/.

	pax-mark -m "${ED}"/opt/viber/Viber \
			"${ED}"/opt/viber/QtWebEngineProcess

	fperms -R +x /opt/viber/Viber \
		/opt/viber/libexec/QtWebEngineProcess \
		/opt/viber/plugins/{audio,generic,geoservices,imageformats,mediaservice,platforminputcontexts,platforms,printsupport,sqldrivers,xcbglintegrations}/ \
		/opt/viber/qml/Qt/labs/animation/liblabsanimationplugin.so \
		/opt/viber/qml/Qt/labs/calendar/libqtlabscalendarplugin.so \
		/opt/viber/qml/Qt/labs/folderlistmodel/libqmlfolderlistmodelplugin.so \
		/opt/viber/qml/Qt/labs/location/liblocationlabsplugin.so \
		/opt/viber/qml/Qt/labs/lottieqt/liblottieqtplugin.so \
		/opt/viber/qml/Qt/labs/platform/libqtlabsplatformplugin.so \
		/opt/viber/qml/Qt/labs/qmlmodels/liblabsmodelsplugin.so \
		/opt/viber/qml/Qt/labs/settings/libqmlsettingsplugin.so \
		/opt/viber/qml/Qt/labs/sharedimage/libsharedimageplugin.so \
		/opt/viber/qml/Qt/labs/wavefrontmesh/libqmlwavefrontmeshplugin.so \
		/opt/viber/qml/QtGraphicalEffects/private/libqtgraphicaleffectsprivate.so \
		/opt/viber/qml/QtGraphicalEffects/libqtgraphicaleffectsplugin.so \
		/opt/viber/qml/QtLocation/libdeclarative_location.so \
		/opt/viber/qml/QtMultimedia/libdeclarative_multimedia.so \
		/opt/viber/qml/QtPositioning/libdeclarative_positioning.so \
		/opt/viber/qml/QtQml/Models.2/libmodelsplugin.so \
		/opt/viber/qml/QtQml/RemoteObjects/libqtqmlremoteobjects.so \
		/opt/viber/qml/QtQml/StateMachine/libqtqmlstatemachine.so \
		/opt/viber/qml/QtQml/WorkerScript.2/libworkerscriptplugin.so \
		/opt/viber/qml/QtQml/libqmlplugin.so \
		/opt/viber/qml/QtQuick/Controls/Styles/Flat/libqtquickextrasflatplugin.so \
		/opt/viber/qml/QtQuick/Controls/libqtquickcontrolsplugin.so \
		/opt/viber/qml/QtQuick/Controls.2/Fusion/libqtquickcontrols2fusionstyleplugin.so \
		/opt/viber/qml/QtQuick/Controls.2/Imagine/libqtquickcontrols2imaginestyleplugin.so \
		/opt/viber/qml/QtQuick/Controls.2/Material/libqtquickcontrols2materialstyleplugin.so \
		/opt/viber/qml/QtQuick/Controls.2/Universal/libqtquickcontrols2universalstyleplugin.so \
		/opt/viber/qml/QtQuick/Controls.2/libqtquickcontrols2plugin.so \
		/opt/viber/qml/QtQuick/Dialogs/Private/libdialogsprivateplugin.so \
		/opt/viber/qml/QtQuick/Dialogs/libdialogplugin.so \
		/opt/viber/qml/QtQuick/Extras/libqtquickextrasplugin.so \
		/opt/viber/qml/QtQuick/Layouts/libqquicklayoutsplugin.so \
		/opt/viber/qml/QtQuick/LocalStorage/libqmllocalstorageplugin.so \
		/opt/viber/qml/QtQuick/Particles.2/libparticlesplugin.so \
		/opt/viber/qml/QtQuick/PrivateWidgets/libwidgetsplugin.so \
		/opt/viber/qml/QtQuick/Scene2D/libqtquickscene2dplugin.so \
		/opt/viber/qml/QtQuick/Scene3D/libqtquickscene3dplugin.so \
		/opt/viber/qml/QtQuick/Shapes/libqmlshapesplugin.so \
		/opt/viber/qml/QtQuick/Templates.2/libqtquicktemplates2plugin.so \
		/opt/viber/qml/QtQuick/Timeline/libqtquicktimelineplugin.so \
		/opt/viber/qml/QtQuick/VirtualKeyboard/Settings/libqtquickvirtualkeyboardsettingsplugin.so \
		/opt/viber/qml/QtQuick/VirtualKeyboard/Styles/libqtquickvirtualkeyboardstylesplugin.so \
		/opt/viber/qml/QtQuick/VirtualKeyboard/libqtquickvirtualkeyboardplugin.so \
		/opt/viber/qml/QtQuick/Window.2/libwindowplugin.so \
		/opt/viber/qml/QtQuick/XmlListModel/libqmlxmllistmodelplugin.so \
		/opt/viber/qml/QtQuick.2/libqtquick2plugin.so \
		/opt/viber/qml/QtWebChannel/libdeclarative_webchannel.so \
		/opt/viber/qml/QtWebEngine/libqtwebengineplugin.so

	dosym ../../opt/viber/Viber /usr/bin/Viber
}
