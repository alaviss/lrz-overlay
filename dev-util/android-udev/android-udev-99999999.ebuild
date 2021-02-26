# Copyright 2021 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit git-r3 udev user

DESCRIPTION="Udev rules for development access to Android devices"
HOMEPAGE="https://github.com/M0Rf30/android-udev-rules"
KEYWORDS=""
SLOT=0
LICENSE="GPL-3+"
EGIT_REPO_URI="$HOMEPAGE.git"

RDEPEND="
	acct-group/adbusers
	virtual/udev
	"
DEPEND=""

src_install() {
	udev_dorules 51-android.rules
}
