# Copyright 2020 Leorize <leorize+oss@disroot.org>
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit mercurial meson

DESCRIPTION="Wofi is a launcher/menu program for wlroots based wayland compositors such as sway"
HOMEPAGE="https://hg.sr.ht/~scoopta/wofi"
KEYWORDS=""
SLOT=0
LICENSE="GPL-3+"
EHG_REPO_URI="https://hg.sr.ht/~scoopta/wofi"

RDEPEND="
  x11-libs/gtk+:3[wayland]
"
DEPEND="$RDEPEND"
