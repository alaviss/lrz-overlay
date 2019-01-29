# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=6

inherit gnome2-utils git-r3 uxp xdg-utils

DESRCIPTION="An open-source web browser focusing on efficiency and customization"
HOMEPAGE="https://www.palemoon.org/"
KEYWORDS=""
SLOT=0
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="-official-branding"
EGIT_REPO_URI="https://github.com/MoonchildProductions/UXP.git"

pkg_pretend() {
  if use official-branding; then
    elog "You are enabling official branding. This build will be marked as"
    elog "private. You may not distribute the resulting binaries to any users"
    elog "online. Doing so put you into legal problems with"
    elog "Moonchild Productions."
    elog
    elog "Official branding can be disabled by emerging $PN *without* "
    elog "the official-branding USE flag."
  fi
}

src_configure() {
  uxp_src_configure
  if use official-branding; then
    uxpconfig_add_ac --enable-official-branding
    uxpconfig_add_ac --enable-private-build
  fi
}

src_install() {
  uxp_src_install

  local version=$(cat application/palemoon/config/version.txt)
  [[ -z $version ]] && die "Unable to get palemoon version"
  rm "$ED"/usr/lib/palemoon-$version/palemoon-bin
  dosym palemoon /usr/lib/palemoon-$version/palemoon-bin

  if ! use official-branding; then
    icns="16 28 32"
    brand="application/$PN/branding/unofficial"
    bname="newmoon"
  else
    icns="16 22 24 32 48 256"
    brand="application/$PN/branding/official"
    bname="$PN"
  fi

  for s in $icns
  do
    insinto /usr/share/icons/hicolor/${s}x$s/apps
    newins "$brand/default$s.png" "$PN.png"
  done

  insinto /usr/share/icons/hicolor/64x64/apps
  newins "$brand/content/icon64.png" "$PN.png"
  insinto /usr/share/icons/hicolor/128x128/apps
  newins "$brand/mozicon128.png" "$PN.png"
  insinto /usr/share/icons/hicolor/192x192/apps
  newins "$brand/content/about-logo.png" "$PN.png"
  insinto /usr/share/icons/hicolor/384x384/apps
  newins "$brand/content/about-logo@2x.png" $PN.png

  insinto /usr/share/applications
  doins "$brand/$bname.desktop"
}

pkg_postinst() {
  xdg_desktop_database_update
  gnome2_icon_cache_update
}

pkg_postrm() {
  pkg_postinst
}
