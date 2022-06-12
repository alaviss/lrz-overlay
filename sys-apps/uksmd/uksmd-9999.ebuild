# Copyright 2021 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=8

inherit git-r3 meson

DESCRIPTION="Dynamically allocate resources to the active user"
HOMEPAGE="https://gitlab.com/post-factum/uksmd"
EGIT_REPO_URI="${HOMEPAGE}"
KEYWORDS=""
SLOT=0
LICENSE="MIT"
SRC_URI=""

BDEPEND="
	sys-apps/systemd
"
DEPEND="
	sys-process/procps:=
	sys-libs/libcap-ng:=
"
RDEPEND="${DEPEND}"
