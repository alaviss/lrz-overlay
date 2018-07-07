# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=6
DESCRIPTION="A friendly semi formal, semi condensed, semi sans serif, font"
SRC_URI="https://github.com/google/fonts/raw/90abd17b4f97671435798b6147b698aa9087612f/ofl/cantoraone/CantoraOne-Regular.ttf -> $P-regular.ttf"
HOMEPAGE="https://fontlibrary.org/en/font/gelasio"
KEYWORDS="~amd64"
SLOT=0
LICENSE="OFL-1.1"
S="$WORKDIR"

inherit font

FONT_SUFFIX="ttf"

src_unpack() {
  cp "$DISTDIR/$P-regular.ttf" "$WORKDIR/CantoraOne-Regular.ttf"
}
