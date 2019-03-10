# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit bash-completion-r1 cmake-utils

DESCRIPTION="A bus interface that lets you change screen brightness and temperature."
HOMEPAGE="https://github.com/FedeDP/$PN"
KEYWORDS="~amd64"
SLOT=0
LICENSE="GPL-3"
IUSE="elogind xrandr dpms xscreensaver brightness-control"
SRC_URI="https://github.com/FedeDP/$PN/archive/$PV.tar.gz -> $P.tar.gz"

DEPEND="
  elogind? ( sys-auth/elogind )
  !elogind? ( >=sys-apps/systemd-221 )
  dev-libs/popt
  sci-libs/gsl
  dev-libs/libconfig
"
RDEPEND="
  $DEPEND
  >=sys-power/clightd-2.0
"

S="$WORKDIR/Clight-$PV"

src_install() {
  dobashcomp Extra/clight
  cmake-utils_src_install
}

pkg_postinst() {
  if ! has_version "app-misc/geoclue:2.0"; then
    elog "Install 'app-misc/geoclue:2.0' for automated location retrieval."
  fi
  if ! has_version "sys-power/upower"; then
    elog "Install 'sys-power/upower' for captures timeout, different ambient brightness, etc."
  fi
}
