# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
SRC_URI="https://api.github.com/repos/libfuse/sshfs/tarball/sshfs-3.7.2 -> sshfs-3.7.2.tar.gz"

LICENSE="GPL-2"
KEYWORDS="*"
SLOT="0"

DEPEND="sys-fs/fuse:3
	dev-libs/glib"
RDEPEND="${DEPEND}
	net-misc/openssh"
BDEPEND="dev-python/docutils
	virtual/pkgconfig"

# requires root privs and specific localhost sshd setup
RESTRICT="test"

DOCS=( AUTHORS ChangeLog.rst README.rst )

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/libfuse-sshfs-* ${S} || die
}