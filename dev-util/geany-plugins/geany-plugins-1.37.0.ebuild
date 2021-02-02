# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of different plugins for Geany"
HOMEPAGE="https://plugins.geany.org"
SRC_URI="https://github.com/geany/geany-plugins/archive/1.37.0.tar.gz -> geany-plugins-1.37.0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="nls scope +utilslib +addons +autoclose +automark +codenav +commander debugger +defineformat geanyctags +geanyextrasel +geanyinsertnum +latex geanylua +geanymacro +geanyminiscript +geanynumberedbookmarks geanypg +geanyprj +geanyvc geniuspaste gitchangebar +keyrecord +lineoperations +lipsum markdown +overview +pairtaghighlighter +pohelper pretty-printer +projectorganizer scope +sendmail +shiftcolumn spellcheck +tableconvert +treebrowser +vimode workbench +xmlsnippets"

RDEPEND="
	dev-libs/glib:2
	dev-util/geany
	debugger? ( x11-libs/vte:2.91 )
geanyctags? ( dev-util/ctags )
geanylua? ( dev-lang/lua:0= )
geanypg? ( app-crypt/gpgme:1= )
geniuspaste? ( net-libs/libsoup:2.4 )
gitchangebar? ( dev-libs/libgit2:= )
markdown? ( app-text/discount
net-libs/webkit-gtk:4 )
pretty-printer? ( dev-libs/libxml2:2 )
scope? ( x11-libs/vte:2.91
sys-devel/gdb )
spellcheck? ( app-text/enchant:= )
workbench? ( dev-libs/libgit2:= )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_configure() {
	local myeconfargs=(
		--disable-cppcheck
		--disable-extra-c-warnings
		$(use_enable nls)
		--enable-utilslib
		$(use_enable utilslib)
$(use_enable addons)
$(use_enable autoclose)
$(use_enable automark)
$(use_enable codenav)
$(use_enable commander)
$(use_enable debugger)
$(use_enable defineformat)
--disable-devhelp
$(use_enable geanyctags)
--disable-geanydoc
$(use_enable geanyextrasel)
--disable-geanygendoc
$(use_enable geanyinsertnum)
$(use_enable latex)
$(use_enable geanylua)
$(use_enable geanymacro)
$(use_enable geanyminiscript)
$(use_enable geanynumberedbookmarks)
$(use_enable geanypg)
$(use_enable geanyprj)
--disable-geanypy
$(use_enable geanyvc)
$(use_enable geniuspaste)
$(use_enable gitchangebar)
$(use_enable keyrecord)
$(use_enable lineoperations)
$(use_enable lipsum)
$(use_enable markdown)
--disable-multiterm
$(use_enable overview)
$(use_enable pairtaghighlighter)
$(use_enable pohelper)
$(use_enable pretty-printer)
$(use_enable projectorganizer)
$(use_enable scope)
$(use_enable sendmail)
$(use_enable shiftcolumn)
$(use_enable spellcheck)
$(use_enable tableconvert)
$(use_enable treebrowser)
--disable-updatechecker
$(use_enable vimode)
--disable-webhelper
$(use_enable workbench)
$(use_enable xmlsnippets)
	)

	./autogen.sh "${myeconfargs[@]}"
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die

	# make installs all translations if LINGUAS is empty
	if [[ -z "${LINGUAS-x}" ]]; then
		rm -r "${ED}/usr/share/locale/" || die
	fi
}