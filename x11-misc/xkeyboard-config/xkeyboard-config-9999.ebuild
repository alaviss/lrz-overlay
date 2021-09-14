# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-any-r1 git-r3

DESCRIPTION="X keyboard configuration database (with DreymaR patch)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/XKeyboardConfig https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config"

EGIT_REPO_URI="https://github.com/DreymaR/BigBagKbdTrixXKB.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/bbkt-mod"
XKBVER=2.23.1 # The xkb version used by the mod

SRC_URI="https://www.x.org/releases/individual/data/${PN}/${PN}-${XKBVER}.tar.bz2"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/libxslt
	sys-devel/gettext
"

S="${WORKDIR}/${PN}-${XKBVER}"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
	unpack "${A}"
}

src_configure() {
	econf --with-xkb-base="${EPREFIX}/usr/share/X11/xkb" --enable-compat-rules
}

src_install() {
	emake DESTDIR="${D}" install

	cd "${WORKDIR}/bbkt-mod" # Install the mod
	bash ./install-dreymar-xmod.sh -s -c "${ED}/usr/share/X11" -o -n
	install -Dm755 setxkb.sh "${ED}/usr/bin/setxkb.sh"
}
