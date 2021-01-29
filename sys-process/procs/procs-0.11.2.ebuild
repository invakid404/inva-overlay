# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
addr2line-0.14.1
adler-0.2.3
ansi_term-0.11.0
anyhow-1.0.38
arrayref-0.3.6
arrayvec-0.5.2
atty-0.2.14
autocfg-1.0.1
backtrace-0.3.56
backtrace-sys-0.1.23
base64-0.9.3
base64-0.13.0
bitflags-1.2.1
blake2b_simd-0.5.11
byte-unit-4.0.9
byteorder-1.4.2
bytes-0.5.6
bytes-1.0.1
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
console-0.14.0
constant_time_eq-0.1.5
crc32fast-1.2.1
crossbeam-utils-0.8.1
crossterm-0.18.2
crossterm_winapi-0.6.2
directories-3.0.1
dirs-1.0.5
dirs-sys-0.3.5
dockworker-0.0.22
encode_unicode-0.3.6
errno-0.2.7
errno-dragonfly-0.1.1
failure-0.1.8
failure_derive-0.1.8
filetime-0.2.14
flate2-1.0.19
fnv-1.0.7
form_urlencoded-1.0.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.12
futures-channel-0.3.12
futures-core-0.3.12
futures-executor-0.3.12
futures-io-0.3.12
futures-macro-0.3.12
futures-sink-0.3.12
futures-task-0.3.12
futures-util-0.3.12
gcc-0.3.55
getch-0.2.1
getrandom-0.1.16
gimli-0.23.0
h2-0.2.7
hashbrown-0.9.1
heck-0.3.2
hermit-abi-0.1.18
hex-0.4.2
http-0.2.3
http-body-0.3.1
httparse-1.3.4
httpdate-0.3.2
hyper-0.13.9
hyperlocal-0.7.0
hyperx-1.3.0
idna-0.2.0
indexmap-1.6.1
instant-0.1.9
iovec-0.1.4
itoa-0.4.7
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-1.4.0
libc-0.2.83
libproc-0.9.1
lock_api-0.4.2
log-0.4.14
matches-0.1.8
memchr-2.3.4
mime-0.3.16
miniz_oxide-0.4.3
mio-0.6.23
mio-0.7.7
mio-named-pipes-0.1.7
mio-uds-0.6.8
miow-0.2.2
miow-0.3.6
named_pipe-0.2.4
net2-0.2.37
nix-0.15.0
ntapi-0.3.6
num-integer-0.1.44
num-traits-0.2.14
num_cpus-1.13.0
object-0.23.0
once_cell-1.5.2
pager-0.16.0
parking_lot-0.11.1
parking_lot_core-0.8.2
percent-encoding-2.1.0
pin-project-0.4.27
pin-project-1.0.4
pin-project-internal-0.4.27
pin-project-internal-1.0.4
pin-project-lite-0.1.11
pin-project-lite-0.2.4
pin-utils-0.1.0
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro-hack-0.5.19
proc-macro-nested-0.1.7
proc-macro2-1.0.24
procfs-0.9.1
quote-1.0.8
redox_syscall-0.1.57
redox_syscall-0.2.4
redox_users-0.3.5
regex-1.4.3
regex-syntax-0.6.22
rust-argon2-0.8.3
rustc-demangle-0.1.18
ryu-1.0.5
safemem-0.3.3
scopeguard-1.1.0
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.61
signal-hook-0.1.17
signal-hook-registry-1.3.0
slab-0.4.2
smallvec-1.6.1
socket2-0.3.19
strsim-0.8.0
structopt-0.3.21
structopt-derive-0.4.14
syn-1.0.60
synstructure-0.12.4
tar-0.4.32
termbg-0.2.0
terminal_size-0.1.16
termios-0.2.2
textwrap-0.11.0
thiserror-1.0.23
thiserror-impl-1.0.23
time-0.1.44
tinyvec-1.1.1
tinyvec_macros-0.1.0
tokio-0.2.24
tokio-macros-0.2.6
tokio-util-0.3.1
toml-0.5.8
tower-service-0.3.1
tracing-0.1.22
tracing-core-0.1.17
tracing-futures-0.2.4
try-lock-0.2.3
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
unix_socket-0.5.0
url-2.2.0
users-0.11.0
utf8-width-0.1.4
vec_map-0.8.2
version_check-0.9.2
void-1.0.2
want-0.3.0
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.0+wasi-snapshot-preview1
which-4.0.2
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
xattr-0.2.2
"

inherit cargo

DESCRIPTION="A modern replacement for ps"
HOMEPAGE="https://github.com/dalance/procs"
SRC_URI="https://api.github.com/repos/dalance/procs/tarball/v0.11.2 -> procs-v0.11.2.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT ZLIB"
SLOT="0"
KEYWORDS="*"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/dalance-procs-* ${S} || die
}

src_install() {
	cargo_src_install

	dodoc README.md
}