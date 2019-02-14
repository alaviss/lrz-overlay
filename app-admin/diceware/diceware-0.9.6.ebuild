# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

PYTHON_COMPAT=(python2_7 python3_{6,7})

inherit distutils-r1

DESCRIPTION="A passphrase generator following the proposals of Arnold G. Reinhold"
HOMEPAGE="https://github.com/ulif/diceware"
KEYWORDS="amd64"
SLOT=0
LICENSE="GPL-3+"
IUSE="test"
REQUIRED_USE="$PYTHON_REQUIRED_USE"
SRC_URI="mirror://pypi/d/$PN/$P.tar.gz"

RDEPEND="$PYTHON_DEPS"
DEPEND="$RDEPEND
  dev-python/setuptools[$PYTHON_USEDEP]
  test? ( >=dev-python/pytest-2.8.3[$PYTHON_USEDEP] )"

src_install() {
  distutils-r1_src_install
  doman diceware.1
}
