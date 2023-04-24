# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit meson pam pax-utils python-any-r1 systemd user xdg-utils

DESCRIPTION="Policy framework for controlling privileges for system-wide services"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/polkit https://gitlab.freedesktop.org/polkit/polkit"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.gz"

S="${WORKDIR}"/${PN}-v.${PV}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="+duktape examples gtk +introspection kde pam selinux systemd test"
RESTRICT="!test? ( test )"

BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xsl-stylesheets
	dev-libs/glib
	dev-libs/gobject-introspection-common
	dev-libs/libxslt
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
	test? (
		$(python_gen_any_dep '
			dev-python/dbus-python[${PYTHON_USEDEP}]
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
	)
"
DEPEND="
	dev-libs/glib:2
	dev-libs/expat
	duktape? ( dev-lang/duktape:= )
	!duktape? ( dev-lang/spidermonkey:91[-debug] )
	pam? (
		sys-auth/pambase
		sys-libs/pam
	)
	!pam? ( virtual/libcrypt:= )
	systemd? ( sys-apps/systemd:0=[policykit] )
	!systemd? ( sys-auth/elogind )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-policykit )
"
PDEPEND="
	gtk? ( || (
		>=gnome-extra/polkit-gnome-0.105
		>=lxde-base/lxsession-0.5.2
	) )
	kde? ( kde-plasma/polkit-kde-agent )
"

DOCS=( docs/TODO HACKING.md NEWS.md README.md )

QA_MULTILIB_PATHS="
	usr/lib/polkit-1/polkit-agent-helper-1
	usr/lib/polkit-1/polkitd"
  
python_check_deps() {
	python_has_version "dev-python/dbus-python[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	local u=polkitd
	local g=polkitd
	local h=/var/lib/polkit-1

	enewgroup ${g}
	enewuser ${u} -1 -1 ${h} ${g}
	esethome ${u} ${h}

	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# bug #401513
	sed -i -e 's|unix-group:wheel|unix-user:0|' src/polkitbackend/*-default.rules || die
}

src_configure() {
	xdg_environment_reset

	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Dauthfw="$(usex pam pam shadow)"
		-Dexamples=false
		-Dgtk_doc=false
		-Dman=true
		-Dos_type=gentoo
		-Dsession_tracking="$(usex systemd libsystemd-login libelogind)"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Djs_engine=$(usex duktape duktape mozjs)
		$(meson_use introspection)
		$(meson_use test tests)
		$(usex pam "-Dpam_module_dir=$(getpam_mod_dir)" '')
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile

	# Required for polkitd on hardened/PaX due to spidermonkey's JIT
	pax-mark mr src/polkitbackend/.libs/polkitd test/polkitbackend/.libs/polkitbackendjsauthoritytest
}

src_install() {
	meson_src_install

	if use examples ; then
		docinto examples
		dodoc src/examples/{*.c,*.policy*}
	fi

	diropts -m 0700 -o polkitd
	keepdir /usr/share/polkit-1/rules.d
}

pkg_postinst() {
	chmod 0700 "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
	chown polkitd "${EROOT}"/{etc,usr/share}/polkit-1/rules.d
}