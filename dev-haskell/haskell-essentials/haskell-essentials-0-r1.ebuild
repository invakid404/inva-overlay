# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Various useful Haskell libraries"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	sys-libs/ncurses[tinfo]
	dev-haskell/cabal-install
	dev-haskell/attoparsec
	dev-haskell/arithmoi
	dev-haskell/classy-prelude-yesod
	dev-haskell/foreign-store
	dev-haskell/persistent-mongodb
	dev-haskell/stack
	dev-haskell/yesod
	dev-haskell/yesod-auth
	dev-haskell/yesod-bin
	dev-haskell/yesod-static
"
