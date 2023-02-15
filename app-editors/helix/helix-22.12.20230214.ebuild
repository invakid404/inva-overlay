# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
adler-1.0.2
ahash-0.7.6
ahash-0.8.3
aho-corasick-0.7.20
android_system_properties-0.1.5
anyhow-1.0.69
arc-swap-1.6.0
atoi-2.0.0
autocfg-1.1.0
bitflags-1.3.2
bstr-0.2.17
bstr-1.0.1
btoi-0.4.2
bumpalo-3.11.1
bytecount-0.6.3
bytes-1.3.0
bytesize-1.1.0
cassowary-0.3.0
castaway-0.2.2
cc-1.0.79
cfg-if-1.0.0
chardetng-0.1.17
chrono-0.4.23
clipboard-win-4.5.0
clru-0.6.1
codespan-reporting-0.11.1
compact_str-0.6.1
content_inspector-0.2.4
core-foundation-sys-0.8.3
crc32fast-1.3.2
crossbeam-utils-0.8.14
crossterm-0.25.0
crossterm_winapi-0.9.0
cxx-1.0.82
cxx-build-1.0.82
cxxbridge-flags-1.0.82
cxxbridge-macro-1.0.82
dashmap-5.4.0
dirs-4.0.0
dirs-next-2.0.0
dirs-sys-0.3.7
dirs-sys-next-0.1.2
either-1.8.0
encoding_rs-0.8.32
encoding_rs_io-0.1.7
error-code-2.3.1
etcetera-0.4.0
fastrand-1.8.0
fern-0.6.1
filetime-0.2.18
flate2-1.0.25
fnv-1.0.7
form_urlencoded-1.1.0
futures-core-0.3.26
futures-executor-0.3.26
futures-task-0.3.26
futures-util-0.3.26
fuzzy-matcher-0.3.7
getrandom-0.2.8
git-actor-0.17.0
git-attributes-0.8.0
git-bitmap-0.2.0
git-chunk-0.4.0
git-command-0.2.1
git-config-0.15.0
git-config-value-0.10.0
git-credentials-0.9.0
git-date-0.4.0
git-diff-0.26.0
git-discover-0.12.0
git-features-0.26.0
git-glob-0.5.1
git-hash-0.10.1
git-hashtable-0.1.0
git-index-0.12.1
git-lock-3.0.0
git-mailmap-0.9.0
git-object-0.26.0
git-odb-0.40.0
git-pack-0.30.0
git-path-0.7.0
git-prompt-0.3.0
git-quote-0.4.0
git-ref-0.23.0
git-refspec-0.7.0
git-repository-0.32.0
git-revision-0.10.0
git-sec-0.6.0
git-tempfile-3.0.0
git-traverse-0.22.0
git-url-0.13.0
git-validate-0.7.1
git-worktree-0.12.0
globset-0.4.9
grep-matcher-0.1.5
grep-regex-0.1.10
grep-searcher-0.1.10
hashbrown-0.12.3
hashbrown-0.13.2
hermit-abi-0.1.19
hex-0.4.3
home-0.5.4
human_format-1.0.3
iana-time-zone-0.1.53
iana-time-zone-haiku-0.1.1
idna-0.3.0
ignore-0.4.18
imara-diff-0.1.5
indexmap-1.9.2
indoc-2.0.0
instant-0.1.12
io-close-0.3.7
itoa-1.0.4
js-sys-0.3.60
lazy_static-1.4.0
libc-0.2.139
libloading-0.7.4
link-cplusplus-1.0.7
lock_api-0.4.9
log-0.4.17
lsp-types-0.94.0
memchr-2.5.0
memmap2-0.5.8
minimal-lexical-0.2.1
miniz_oxide-0.6.2
mio-0.8.5
nix-0.26.1
nom-7.1.1
nom8-0.2.0
num-integer-0.1.45
num-traits-0.2.15
num_cpus-1.14.0
num_threads-0.1.6
once_cell-1.17.0
parking_lot-0.11.2
parking_lot-0.12.1
parking_lot_core-0.8.6
parking_lot_core-0.9.4
percent-encoding-2.2.0
pin-project-lite-0.2.9
pin-utils-0.1.0
proc-macro2-1.0.47
prodash-23.0.0
pulldown-cmark-0.9.2
quick-error-2.0.1
quickcheck-1.0.3
quote-1.0.21
rand-0.8.5
rand_core-0.6.4
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.7.1
regex-automata-0.1.10
regex-syntax-0.6.28
remove_dir_all-0.5.3
ropey-1.6.0
rustversion-1.0.9
ryu-1.0.11
same-file-1.0.6
scopeguard-1.1.0
scratch-1.0.2
serde-1.0.152
serde_derive-1.0.152
serde_json-1.0.92
serde_repr-0.1.9
serde_spanned-0.6.1
sha1_smol-1.0.0
signal-hook-0.3.15
signal-hook-mio-0.2.3
signal-hook-registry-1.4.0
signal-hook-tokio-0.3.1
slab-0.4.7
slotmap-1.0.6
smallvec-1.10.0
smartstring-1.0.1
smawk-0.3.1
socket2-0.4.7
static_assertions-1.1.0
str-buf-1.0.6
str_indices-0.4.0
syn-1.0.104
tempfile-3.3.0
termcolor-1.1.3
termini-0.1.4
textwrap-0.16.0
thiserror-1.0.38
thiserror-impl-1.0.38
thread_local-1.1.4
threadpool-1.8.1
time-0.3.17
time-core-0.1.0
time-macros-0.2.6
tinyvec-1.6.0
tinyvec_macros-0.1.0
tokio-1.25.0
tokio-macros-1.8.0
tokio-stream-0.1.11
toml-0.7.1
toml_datetime-0.6.1
toml_edit-0.19.1
tree-sitter-0.20.9
unicase-2.6.0
unicode-bidi-0.3.8
unicode-bom-1.1.4
unicode-general-category-0.6.0
unicode-ident-1.0.5
unicode-linebreak-0.1.4
unicode-normalization-0.1.22
unicode-segmentation-1.10.1
unicode-width-0.1.10
url-2.3.1
version_check-0.9.4
walkdir-2.3.2
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
which-4.4.0
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-0.40.0
windows-sys-0.42.0
windows_aarch64_gnullvm-0.40.0
windows_aarch64_gnullvm-0.42.0
windows_aarch64_msvc-0.40.0
windows_aarch64_msvc-0.42.0
windows_i686_gnu-0.40.0
windows_i686_gnu-0.42.0
windows_i686_msvc-0.40.0
windows_i686_msvc-0.42.0
windows_x86_64_gnu-0.40.0
windows_x86_64_gnu-0.42.0
windows_x86_64_gnullvm-0.40.0
windows_x86_64_gnullvm-0.42.0
windows_x86_64_msvc-0.40.0
windows_x86_64_msvc-0.42.0
"

inherit cargo

DESCRIPTION="Alternative to find that provides sensible defaults for 80% of the use cases"
HOMEPAGE="https://github.com/helix-editor/helix"
SRC_URI="
	https://github.com/helix-editor/helix/archive/715c4b24d94c9e2fa70d5d59ce658b89fbde0392.tar.gz -> helix-22.12.20230214-715c4b24d94c9e2fa70d5d59ce658b89fbde0392.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="Apache-2.0 Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 ISC MIT MPL-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

src_unpack() {
	cargo_src_unpack
	rm -rf "${S}"
	mv "${WORKDIR}"/helix-715c4b24d94c9e2fa70d5d59ce658b89fbde0392 "${S}" || die
}

src_compile() {
	export HELIX_DISABLE_AUTO_GRAMMAR_BUILD=1

	cargo_src_compile
}

src_install() {
	rm -rf ${S}/runtime/grammars/sources

	insinto /usr/share/helix
	doins -r runtime
 
	use doc && dodoc README.md CHANGELOG.md
	use doc && dodoc -r docs/

	cargo_src_install --path helix-term
}

pkg_postinst() {
	elog "You will need to copy /usr/share/helix/runtime into your \$HELIX_RUNTIME"
	elog "For syntax highlighting and other features. "
	elog ""
	elog "Run: "
	elog "cp -r /usr/share/helix/runtime ~/.config/helix/runtime"
	elog ""
	elog "To install tree-sitter grammars for helix run the following:"
	elog "hx -g fetch"
	elog "hx -g build"
}