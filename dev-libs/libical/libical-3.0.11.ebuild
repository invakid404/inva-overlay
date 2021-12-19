# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
VALA_USE_DEPEND="vapigen"
inherit cmake python-any-r1 vala

DESCRIPTION="Implementation of basic iCAL protocols"
HOMEPAGE="https://github.com/libical/libical"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( MPL-2.0 LGPL-2.1 )"
SLOT="0/3"
KEYWORDS="*"
IUSE="berkdb doc examples +glib +introspection static-libs vala"

REQUIRED_USE="introspection? ( glib ) vala? ( introspection )"

COMMON_DEPEND="
	dev-libs/icu:=
	berkdb? ( sys-libs/db:= )
	glib? ( dev-libs/glib:2 )
"
DEPEND="
	${COMMON_DEPEND}
	glib? ( dev-libs/libxml2:2 )
"
RDEPEND="
	${COMMON_DEPEND}
	sys-libs/timezone-data
"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		glib? ( dev-util/gtk-doc )
	)
	introspection? ( dev-libs/gobject-introspection )
	vala? ( $(vala_depend) )
"

DOCS=(
	AUTHORS ReadMe.txt ReleaseNotes.txt TEST THANKS TODO
	doc/{AddingOrModifyingComponents,UsingLibical}.txt
)

python_check_deps() {
	has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]"
}

src_prepare() {
	sed -i \
		-e 's/-L\${libdir}//g' \
		libical.pc.in

	cmake_src_prepare

	use examples || cmake_comment_add_subdirectory examples
	use vala && vala_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package berkdb BDB)
		-DICAL_BUILD_DOCS=$(usex doc)
		-DICAL_GLIB=$(usex glib)
		-DGOBJECT_INTROSPECTION=$(usex introspection)
		-DSHARED_ONLY=$(usex !static-libs)
		-DLIBICAL_BUILD_TESTING=no
		-DICAL_GLIB_VAPI=$(usex vala)
	)
	if use vala; then
		mycmakeargs+=(
			-DVALAC="${VALAC}"
			-DVAPIGEN="${VAPIGEN}"
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile docs
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/apidocs/html/. )

	cmake_src_install

	if use examples; then
		rm examples/CMakeLists.txt || die
		dodoc -r examples
	fi
}
