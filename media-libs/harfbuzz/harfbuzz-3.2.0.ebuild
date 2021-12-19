# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit flag-o-matic meson python-any-r1 xdg-utils

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/HarfBuzz"

SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="*"

LICENSE="Old-MIT ISC icu"
SLOT="0"

IUSE="+cairo debug doc experimental +glib +graphite icu +introspection test +truetype"
RESTRICT="!test? ( test )"
REQUIRED_USE="introspection? ( glib )"

RDEPEND="
	cairo? ( x11-libs/cairo:= )
	glib? ( dev-libs/glib:2 )
	graphite? ( media-gfx/graphite2:= )
	icu? ( dev-libs/icu:= )
	introspection? ( dev-libs/gobject-introspection:= )
	truetype? ( media-libs/freetype:2 )
"
DEPEND="
	${RDEPEND}
	dev-libs/gobject-introspection-common
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-util/glib-utils )
"

pkg_setup() {
	python-any-r1_pkg_setup
	if ! use debug ; then
		append-cppflags -DHB_NDEBUG
	fi
}

src_prepare() {
	default

	xdg_environment_reset

	sed -i \
		-e '/tests\/macos\.tests/d' \
		test/shape/data/in-house/Makefile.sources \
		|| die # bug 726120

	# bug 618772
	append-cxxflags -std=c++14

	# bug 790359
	filter-flags -fexceptions -fthreadsafe-statics

	# bug 762415
	local pyscript
	for pyscript in $(find -type f -name "*.py") ; do
		python_fix_shebang -q "${pyscript}"
	done
}

multilib_src_configure() {
	# harfbuzz-gobject only used for instrospection, bug #535852
	local emesonargs=(
		-Dcoretext="disabled"
		-Dchafa="disabled"

		$(meson_feature glib)
		$(meson_feature graphite graphite2)
		$(meson_feature icu)
		$(meson_feature introspection gobject)
		$(meson_feature test tests)
		$(meson_feature truetype freetype)

		$(meson_native_use_feature cairo)
		$(meson_native_use_feature doc docs)
		$(meson_native_use_feature introspection)

		$(meson_use experimental experimental_api)
	)
	meson_src_configure
}
