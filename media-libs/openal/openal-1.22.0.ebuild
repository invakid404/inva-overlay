# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="A software implementation of the OpenAL 3D audio API"
HOMEPAGE="https://www.openal-soft.org/"
SRC_URI="https://api.github.com/repos/kcat/openal-soft/tarball/refs/tags/1.22.0 -> openal-soft-1.22.0.tar.gz"

LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS="*"
IUSE="
	alsa coreaudio debug jack oss portaudio pulseaudio sdl sndio qt5
	cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse4_1
	cpu_flags_arm_neon
"

RDEPEND="
	alsa? ( media-libs/alsa-lib[${MULTILIB_USEDEP}] )
	jack? ( virtual/jack[${MULTILIB_USEDEP}] )
	portaudio? ( media-libs/portaudio[${MULTILIB_USEDEP}] )
	pulseaudio? ( media-sound/pulseaudio[${MULTILIB_USEDEP}] )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
	sndio? ( media-sound/sndio:=[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	oss? ( virtual/os-headers )
"

DOCS=( alsoftrc.sample docs/env-vars.txt docs/hrtf.txt ChangeLog README.md )

post_src_unpack() {
	mv "${WORKDIR}"/kcat-openal-soft-* "${S}" || die
}

src_configure() {
	my_configure() {
		local mycmakeargs=(
			-DALSOFT_REQUIRE_ALSA=$(usex alsa)
			-DALSOFT_REQUIRE_COREAUDIO=$(usex coreaudio)
			-DALSOFT_REQUIRE_JACK=$(usex jack)
			-DALSOFT_REQUIRE_OSS=$(usex oss)
			-DALSOFT_REQUIRE_PORTAUDIO=$(usex portaudio)
			-DALSOFT_REQUIRE_PULSEAUDIO=$(usex pulseaudio)
			-DALSOFT_REQUIRE_SDL2=$(usex sdl)
			-DALSOFT_{BACKEND,REQUIRE}_SNDIO=$(usex sndio)
			-DALSOFT_UTILS=$(multilib_is_native_abi && echo "ON" || echo "OFF")
			-DALSOFT_NO_CONFIG_UTIL=$(usex qt5 "$(multilib_is_native_abi && echo "OFF" || echo "ON")" ON)
			-DALSOFT_EXAMPLES=OFF
		)

		if use amd64 || use x86 ; then
			mycmakeargs+=(
				-DALSOFT_CPUEXT_SSE=$(usex cpu_flags_x86_sse)
				-DALSOFT_CPUEXT_SSE2=$(usex cpu_flags_x86_sse2)
				-DALSOFT_CPUEXT_SSE4_1=$(usex cpu_flags_x86_sse4_1)
			)
		fi

		if use arm || use arm64 ; then
			mycmakeargs+=(
				-DALSOFT_CPUEXT_NEON=$(usex cpu_flags_arm_neon)
			)
		fi

		cmake_src_configure
	}

	multilib_parallel_foreach_abi my_configure
}