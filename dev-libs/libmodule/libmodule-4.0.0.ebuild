# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit cmake-utils

DESCRIPTION="C library to easily create modular projects"
HOMEPAGE="https://github.com/FedeDP/libmodule"
KEYWORDS="~amd64"
SLOT=0
LICENSE="GPL-3"
SRC_URI="https://github.com/FedeDP/libmodule/archive/$PV.tar.gz -> $P.tar.gz"
