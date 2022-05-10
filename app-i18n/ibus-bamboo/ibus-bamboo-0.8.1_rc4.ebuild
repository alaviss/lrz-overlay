# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=8

DESCRIPTION="An input method engine for the Vietnamese language."
HOMEPAGE="https://github.com/BambooEngine/$PN"
KEYWORDS="~amd64"
SLOT=0
LICENSE="GPL-3+"
BAMBOO_VER=${PV/_/-}
BAMBOO_VER=${BAMBOO_VER^^}
SRC_URI="https://github.com/BambooEngine/$PN/archive/refs/tags/v$BAMBOO_VER.tar.gz -> $P.tar.gz"

BDEPEND="
  dev-lang/go
  dev-libs/glib
  virtual/pkgconfig
"

DEPEND="
  x11-libs/libX11:=
  x11-libs/libXtst:=
  x11-libs/gtk+:3=
"

RDEPEND="
  $DEPEND
"

S="$WORKDIR/$PN-$BAMBOO_VER"
