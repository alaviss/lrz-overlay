# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit meson python-any-r1

DESCRIPTION="X keyboard configuration database (with DreymaR patch)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"
NAME=${PN}-bbkt
VER=${PV/_p/-}

SRC_URI="
	https://github.com/SeerLite/${NAME}/releases/download/${NAME}-${VER}/${NAME}-${VER}.tar.bz2
	"
KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND=""
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	sys-devel/gettext
"

S="${WORKDIR}/${NAME}-${VER}"
pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dxkb-base="${EPREFIX}/usr/share/X11/xkb"
		-Dcompat-rules=true
	)
	meson_src_configure
}
