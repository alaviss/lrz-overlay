# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=6
DESCRIPTION="X keyboard configuration database (DreymaR version)"
HOMEPAGE="https://github.com/DreymaR/BigBagKbdTrixXKB"
KEYWORDS=""
SLOT=0
LICENSE="MIT"

inherit git-r3
EGIT_REPO_URI="https://github.com/DreymaR/BigBagKbdTrixXKB.git"

src_install() {
  bash ./install-dreymar-xmod.sh -i "$D/usr/share/X11" -n
  mv "$D/usr/share/X11/"{d,}xkb
  dobin "$D/usr/share/X11/setxkb.sh"
  rm "$D/usr/share/X11/setxkb.sh"
}
