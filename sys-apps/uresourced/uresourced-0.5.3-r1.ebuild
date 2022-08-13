# Copyright 2021 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=8

inherit meson

DESCRIPTION="Dynamically allocate resources to the active user"
HOMEPAGE="https://gitlab.freedesktop.org/benzea/uresourced"
KEYWORDS="~amd64"
SLOT=0
LICENSE="MIT"
SRC_URI="https://gitlab.freedesktop.org/benzea/uresourced/-/archive/v${PV}/uresourced-v${PV}.tar.bz2"
IUSE="+appmanagement"

BDEPEND="
	dev-libs/glib
"
DEPEND="
	dev-libs/glib
	sys-apps/systemd
	appmanagement? ( media-video/pipewire:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-v${PV}"

src_configure() {
	local emesonargs=(
		$(meson_use appmanagement)
	)
	meson_src_configure
}
