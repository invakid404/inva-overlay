# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Dependencies needed for the development version of metatools"

LICENSE=""
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	dev-db/mongodb
	dev-python/subpop
	dev-python/pymongo
	dev-python/pyyaml
	dev-python/jinja
	dev-python/lxml
	www-servers/tornado
	dev-python/xmltodict
	dev-python/httpx
	dev-python/aiohttp
	dev-python/aiodns
	dev-python/typing-extensions
	dev-python/toml
	dev-python/beautifulsoup
	dev-python/packaging
"

