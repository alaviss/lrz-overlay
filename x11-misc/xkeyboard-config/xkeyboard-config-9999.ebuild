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
  bash ./install-dreymar-xmod.sh -i "$ED/usr/share/X11" -n
  mv "$ED/usr/share/X11/"{d,}xkb
  dobin "$ED/usr/share/X11/setxkb.sh"
  rm "$ED/usr/share/X11/setxkb.sh"

  dodir /usr/share/pkgconfig
  cat << EOF > "$ED/usr/share/pkgconfig/xkeyboard-config.pc"
prefix=$EPREFIX/usr
datarootdir=\${prefix}/share
datadir=\${datarootdir}
xkb_base=\${datarootdir}/X11/xkb

Name: XKeyboardConfig
Description: X Keyboard configuration data
Version: 2.25
EOF
}
