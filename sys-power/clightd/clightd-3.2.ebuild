# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit cmake-utils

DESCRIPTION="A bus interface that lets you change screen brightness and temperature."
HOMEPAGE="https://github.com/FedeDP/$PN"
KEYWORDS="~amd64"
SLOT=0
LICENSE="GPL-3"
IUSE="elogind xrandr dpms xscreensaver brightness-control"
SRC_URI="https://github.com/FedeDP/$PN/archive/$PV.tar.gz -> $P.tar.gz"

RDEPEND="
  elogind? ( sys-auth/elogind )
  !elogind? ( >=sys-apps/systemd-221 )
  virtual/libudev
  >=dev-libs/libmodule-3.1.0
  sys-auth/polkit[introspection]
  xrandr? ( x11-libs/libXrandr )
  dpms? ( x11-libs/libXext )
  xscreensaver? ( x11-libs/libXScrnSaver )
  brightness-control? ( >=app-misc/ddcutil-0.9.0 )
"
DEPEND="$RDEPEND"

S="$WORKDIR/Clightd-$PV"

src_configure() {
  local mycmakeargs=(
    -DENABLE_DDC=$(usex brightness-control)
    -DENABLE_DPMS=$(usex dpms)
    -DENABLE_GAMMA=$(usex xrandr)
    -DENABLE_IDLE=$(usex xscreensaver)
  )
  cmake-utils_src_configure
}
