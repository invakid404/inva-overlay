# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler-0.2.3
aho-corasick-0.7.15
arrayref-0.3.6
arrayvec-0.5.2
autocfg-1.0.1
base64-0.10.1
base64-0.12.3
base64-0.13.0
bitflags-1.2.1
blake2b_simd-0.5.11
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byteorder-1.4.2
bytes-0.5.6
bytes-1.0.1
cfg-if-0.1.10
cfg-if-1.0.0
chrono-0.4.19
clap-2.33.3
constant_time_eq-0.1.5
cookie-0.12.0
crc32fast-1.2.1
crossbeam-utils-0.8.1
digest-0.8.1
dirs-2.0.2
dirs-sys-0.3.5
dtoa-0.4.7
fake-simd-0.1.2
flate2-1.0.20
fnv-1.0.7
form_urlencoded-1.0.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.12
futures-channel-0.3.12
futures-core-0.3.12
futures-io-0.3.12
futures-sink-0.3.12
futures-task-0.3.12
futures-util-0.3.12
generic-array-0.12.3
getrandom-0.1.16
getrandom-0.2.2
h2-0.2.7
hashbrown-0.9.1
headers-0.3.3
headers-core-0.2.0
http-0.2.3
http-body-0.3.1
httparse-1.3.4
httpdate-0.3.2
hyper-0.13.9
idna-0.2.0
indexmap-1.6.1
iovec-0.1.4
itoa-0.4.7
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.84
line-wrap-0.1.1
linked-hash-map-0.5.4
log-0.4.14
marionette-0.1.0
matches-0.1.8
memchr-2.3.4
mime-0.3.16
mime_guess-2.0.3
miniz_oxide-0.4.3
mio-0.6.23
miow-0.2.2
mozdevice-0.3.1
mozprofile-0.7.1
mozrunner-0.12.1
mozversion-0.4.1
msdos_time-0.1.6
net2-0.2.37
num-integer-0.1.44
num-traits-0.2.14
once_cell-1.5.2
opaque-debug-0.2.3
percent-encoding-2.1.0
pin-project-0.4.27
pin-project-1.0.4
pin-project-internal-0.4.27
pin-project-internal-1.0.4
pin-project-lite-0.1.11
pin-project-lite-0.2.4
pin-utils-0.1.0
plist-0.5.5
podio-0.1.7
ppv-lite86-0.2.10
proc-macro2-1.0.24
quote-1.0.8
rand-0.8.3
rand_chacha-0.3.0
rand_core-0.6.1
rand_hc-0.3.0
redox_syscall-0.1.57
redox_syscall-0.2.4
redox_users-0.3.5
regex-1.4.3
regex-syntax-0.6.22
remove_dir_all-0.5.3
rust-argon2-0.8.3
rust-ini-0.10.3
ryu-1.0.5
safemem-0.3.3
same-file-1.0.6
scoped-tls-1.0.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.123
serde_derive-1.0.123
serde_json-1.0.61
serde_repr-0.1.6
serde_urlencoded-0.6.1
serde_yaml-0.8.15
sha-1-0.8.2
slab-0.4.2
socket2-0.3.19
strsim-0.8.0
syn-1.0.60
tempfile-3.2.0
term_size-0.3.2
textwrap-0.11.0
thread_local-1.1.2
time-0.1.43
tinyvec-1.1.1
tinyvec_macros-0.1.0
tokio-0.2.25
tokio-util-0.3.1
tower-service-0.3.1
tracing-0.1.22
tracing-core-0.1.17
tracing-futures-0.2.4
try-lock-0.2.3
typenum-1.12.0
unicase-2.6.0
unicode-bidi-0.3.4
unicode-normalization-0.1.16
unicode-segmentation-1.7.1
unicode-width-0.1.8
unicode-xid-0.2.1
url-2.2.0
urlencoding-1.1.1
uuid-0.8.2
version_check-0.9.2
walkdir-2.3.1
want-0.3.0
warp-0.2.5
wasi-0.9.0+wasi-snapshot-preview1
wasi-0.10.2+wasi-snapshot-preview1
webdriver-0.43.0
winapi-0.2.8
winapi-0.3.9
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.5.1
ws2_32-sys-0.2.1
xml-rs-0.8.3
yaml-rust-0.4.5
zip-0.4.2
"

inherit cargo

DESCRIPTION="Proxy for using WebDriver clients to interact with Gecko-based browsers."
HOMEPAGE="https://hg.mozilla.org/mozilla-central/file/tip/testing/geckodriver"
SRC_URI="https://api.github.com/repos/mozilla/geckodriver/tarball/v0.29.0 -> geckodriver-v0.29.0.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="*"

DOCS=(
	"README.md"
	"CHANGES.md"
	"CONTRIBUTING.md"
	"doc/TraceLogs.md"
)

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/mozilla-geckodriver-* ${S} || die
}

src_install() {
	cargo_src_install
	einstalldocs
}