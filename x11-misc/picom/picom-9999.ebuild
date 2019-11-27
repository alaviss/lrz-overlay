# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="A compositor for X, and a fork of compton"
HOMEPAGE="https://github.com/yshui/picom"

EGIT_REPO_URI="https://github.com/yshui/picom.git"
EGIT_BRANCH="next"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="dbus +drm opengl +pcre"

COMMON_DEPEND="
	dev-libs/libconfig:=
	dev-libs/libev:=
	dev-libs/libxdg-basedir:=
	dev-libs/uthash:=
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	dbus? ( sys-apps/dbus )
	opengl? ( virtual/opengl )
	pcre? ( dev-libs/libpcre:3 )"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/compton
	x11-apps/xprop
	x11-apps/xwininfo"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	x11-base/xorg-proto
	drm? ( x11-libs/libdrm )"

src_compile() {
	local emesonargs=(
		-Ddbus=$(usex dbus true false)
		-Dopengl=$(usex opengl true false)
		-Dregex=$(usex pcre true false)
		-Dvsync_drm=$(usex drm true false)
		-Dwith_docs=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	docinto examples
	dodoc $PN.sample.conf
	if use dbus; then
		dodoc dbus-examples/*
	fi
}
