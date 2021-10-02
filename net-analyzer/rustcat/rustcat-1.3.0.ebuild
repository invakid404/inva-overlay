# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

CRATES="
ansi_term-0.11.0
atty-0.2.14
autocfg-1.0.1
bitflags-1.2.1
cc-1.0.68
cfg-if-1.0.0
clap-2.33.3
clipboard-win-4.2.1
colored-2.0.0
dirs-next-2.0.0
dirs-sys-next-0.1.2
endian-type-0.1.2
error-code-2.3.0
fd-lock-3.0.0
getrandom-0.2.3
heck-0.3.3
hermit-abi-0.1.19
lazy_static-1.4.0
libc-0.2.101
log-0.4.14
memchr-2.4.0
memoffset-0.6.4
nibble_vec-0.1.0
nix-0.22.1
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.29
quote-1.0.9
radix_trie-0.2.1
redox_syscall-0.2.8
redox_users-0.4.0
rustyline-9.0.0
scopeguard-1.1.0
smallvec-1.6.1
str-buf-1.0.5
strsim-0.8.0
structopt-0.3.23
structopt-derive-0.4.16
syn-1.0.76
termios-0.3.3
textwrap-0.11.0
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.2
utf8parse-0.2.0
vec_map-0.8.2
version_check-0.9.3
wasi-0.10.2+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

DESCRIPTION="Modern port listener & Reverse Shell"
HOMEPAGE="https://github.com/robiot/rustcat"
SRC_URI="https://api.github.com/repos/robiot/rustcat/tarball/v1.3.0 -> rustcat-1.3.0.tar.gz
	$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE=""

post_src_unpack() {
	rm -rf "${S}"
	mv "${WORKDIR}"/robiot-rustcat-* "${S}" || die
}

src_install() {
	cargo_src_install

	mv "${ED}"/usr/bin/rc "${ED}/"usr/bin/rustcat
}

pkg_postinst() {
	elog 'Binary installed as "rustbin" instead of "rc" to avoid collisions with OpenRC.'
}