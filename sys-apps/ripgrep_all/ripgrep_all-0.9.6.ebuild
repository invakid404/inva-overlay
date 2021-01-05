# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.12.0
adler32-1.0.4
aho-corasick-0.7.10
ansi_term-0.11.0
arrayref-0.3.6
atty-0.2.14
autocfg-0.1.7
autocfg-1.0.0
backtrace-0.3.48
bincode-1.2.1
bitflags-1.2.1
byteorder-1.3.4
bzip2-0.3.3
bzip2-sys-0.1.8+1.0.8
cachedir-0.1.1
cc-1.0.53
cfg-if-0.1.10
chrono-0.4.11
clap-2.33.1
cloudabi-0.0.3
crc32fast-1.2.0
crossbeam-0.7.3
crossbeam-channel-0.4.2
crossbeam-deque-0.7.3
crossbeam-epoch-0.8.2
crossbeam-queue-0.2.1
crossbeam-utils-0.7.2
encoding_rs-0.8.23
encoding_rs_io-0.1.7
env_logger-0.7.1
exitfailure-0.5.1
failure-0.1.8
failure_derive-0.1.8
fallible-iterator-0.2.0
fallible-streaming-iterator-0.1.9
filetime-0.2.10
fixedbitset-0.1.9
flate2-1.0.14
fnv-1.0.7
fuchsia-cprng-0.1.1
generic-array-0.12.3
getrandom-0.1.14
gimli-0.21.0
glob-0.3.0
heck-0.3.1
hermit-abi-0.1.13
humantime-1.3.0
idna-0.2.0
itoa-0.4.5
jobserver-0.1.21
lazy_static-1.4.0
libc-0.2.70
libsqlite3-sys-0.18.0
linked-hash-map-0.5.3
lmdb-rkv-0.14.0
lmdb-rkv-sys-0.11.0
lock_api-0.2.0
log-0.4.8
lru-cache-0.1.2
lzma-sys-0.1.16
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.3.3
memoffset-0.5.4
miniz_oxide-0.3.6
nom-2.2.1
num-0.2.1
num-complex-0.2.4
num-integer-0.1.42
num-iter-0.1.40
num-rational-0.2.4
num-traits-0.2.11
object-0.19.0
ordered-float-1.0.2
ordermap-0.3.5
parking_lot-0.8.0
parking_lot_core-0.5.0
paste-0.1.12
paste-impl-0.1.12
path-clean-0.1.0
percent-encoding-2.1.0
petgraph-0.4.13
pkg-config-0.3.17
podio-0.1.6
ppv-lite86-0.2.8
proc-macro-error-1.0.2
proc-macro-error-attr-1.0.2
proc-macro-hack-0.5.15
proc-macro2-1.0.13
quick-error-1.2.3
quote-1.0.6
rand-0.6.5
rand-0.7.3
rand_chacha-0.1.1
rand_chacha-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.56
regex-1.3.7
regex-syntax-0.6.17
remove_dir_all-0.5.2
rkv-0.10.4
rusqlite-0.23.1
rustc-demangle-0.1.16
rustc_version-0.2.3
ryu-1.0.4
scopeguard-1.1.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.110
serde_derive-1.0.110
serde_json-1.0.53
size_format-1.0.2
smallvec-0.6.13
smallvec-1.4.0
strsim-0.8.0
structopt-0.3.14
structopt-derive-0.4.7
syn-1.0.22
syn-mid-0.5.0
synstructure-0.12.3
tar-0.4.26
tempfile-3.1.0
term_size-0.3.2
termcolor-1.1.0
textwrap-0.11.0
thread_local-1.0.1
time-0.1.43
tree_magic_fork-0.2.2
typenum-1.12.0
unicode-bidi-0.3.4
unicode-normalization-0.1.12
unicode-segmentation-1.6.0
unicode-width-0.1.7
unicode-xid-0.2.0
url-2.1.1
uuid-0.8.1
vcpkg-0.2.8
vec_map-0.8.2
version_check-0.9.1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.8
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
xattr-0.2.2
xz2-0.1.6
zip-0.5.5
zstd-0.5.1+zstd.1.4.4
zstd-safe-2.0.3+zstd.1.4.4
zstd-sys-1.4.15+zstd.1.4.4
"

inherit cargo

DESCRIPTION="rga is a line-oriented search tool that allows you to look for a regex in a multitude of file types"
HOMEPAGE="https://github.com/phiresky/ripgrep-all"
SRC_URI="https://api.github.com/repos/phiresky/ripgrep-all/tarball/v0.9.6 -> ripgrep_all-v0.9.6.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="GPL"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	virtual/rust
	|| (
		app-text/pandoc-bin
		app-text/pandoc
	)
	app-text/poppler
	media-video/ffmpeg
	sys-apps/ripgrep
"

src_unpack() {
	cargo_src_unpack

	rm -rf ${S}
	mv ${WORKDIR}/phiresky-ripgrep-all-* ${S} || die
}
