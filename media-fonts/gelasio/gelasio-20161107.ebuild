# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=6
DESCRIPTION="A Google font that is metrically compatible with Georgia"
SRC_URI="https://fontlibrary.org/assets/downloads/$PN/4d610887ff4d445cbc639aae7828d139/$PN.zip -> $P.zip"
HOMEPAGE="https://fontlibrary.org/en/font/gelasio"
KEYWORDS="~amd64"
SLOT=0
LICENSE="OFL-1.1"
S="$WORKDIR"

inherit font

FONT_SUFFIX="ttf"
