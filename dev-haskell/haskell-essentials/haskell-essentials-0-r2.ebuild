# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Various useful Haskell libraries"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-haskell/arithmoi
	dev-haskell/attoparsec
	dev-haskell/cabal-install
	dev-haskell/classy-prelude-yesod
	dev-haskell/data-ordlist
	dev-haskell/foreign-store
	dev-haskell/persistent-mongodb
	dev-haskell/stack
	dev-haskell/yesod
	dev-haskell/yesod-auth
	dev-haskell/yesod-bin
	dev-haskell/yesod-static
	sys-libs/ncurses[tinfo]
"
