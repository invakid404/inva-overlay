# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit cmake python-r1

DESCRIPTION="Android platform tools (adb, fastboot, and mkbootimg)"
HOMEPAGE="https://github.com/nmeum/android-tools/ https://developer.android.com/"
SRC_URI="https://github.com/nmeum/android-tools/releases/download/31.0.3p1/android-tools-31.0.3p1.tar.xz -> android-tools-31.0.3p1.tar.xz"
LICENSE="Apache-2.0 BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	app-arch/brotli:=
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/libpcre2:=
	dev-libs/protobuf:=
	sys-libs/zlib:=
	virtual/libusb:1=
"
RDEPEND="
	${DEPEND}
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	dev-lang/go
"

DOCS=()

post_src_unpack() {
	mv "${WORKDIR}"/android-tools-31.0.3p1 "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		# Statically link the bundled boringssl
		-DBUILD_SHARED_LIBS=OFF
	)

	cmake_src_configure
}

src_compile() {
	export GOCACHE="${T}/go-build"
	export GOFLAGS="-mod=vendor"

	cmake_src_compile
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/bin/mkbootimg" || die
	rm "${ED}/usr/bin/unpack_bootimg" || die
	rm "${ED}/usr/bin/repack_bootimg" || die

	if use python; then
		python_foreach_impl python_newexe vendor/mkbootimg/mkbootimg.py mkbootimg
		python_foreach_impl python_newexe vendor/mkbootimg/unpack_bootimg.py unpack_bootimg
		python_foreach_impl python_newexe vendor/mkbootimg/repack_bootimg.py repack_bootimg
	fi

	docinto adb
	dodoc vendor/adb/*.{txt,TXT}

	docinto fastboot
	dodoc vendor/core/fastboot/README.md
}

# vim: syntax=ebuild