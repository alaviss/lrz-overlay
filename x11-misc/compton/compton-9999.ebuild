# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="A compositor for X, and a fork of xcompmgr-dana"
HOMEPAGE="https://github.com/yshui/compton"

EGIT_REPO_URI="https://github.com/yshui/compton.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="dbus +drm opengl +pcre xinerama"

COMMON_DEPEND="
	dev-libs/libconfig:=
	dev-libs/libxdg-basedir:=
	dev-libs/uthash:=
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	dbus? ( sys-apps/dbus )
	opengl? ( virtual/opengl )
	pcre? ( dev-libs/libpcre:3 )
	xinerama? ( x11-libs/libXinerama )"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xprop
	x11-apps/xwininfo"
DEPEND="${COMMON_DEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	x11-base/xorg-proto
	drm? ( x11-libs/libdrm )"

src_compile() {
	local emesonargs=(
		-Dxinerama=$(usex xinerama true false)
		-Dregex=$(usex pcre true false)
		-Dvsync_drm=$(usex drm true false)
		-Dopengl=$(usex opengl true false)
		-Ddbus=$(usex dbus true false)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	docinto examples
	dodoc compton.sample.conf dbus-examples/*
}
