# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

MY_P="${P/_p/-}"

DESCRIPTION="TOMOYO Linux tools"
HOMEPAGE="http://tomoyo.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/tomoyo/49693/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

CDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="
RDEPEND="${CDEPEND}
	sys-apps/which"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_configure() {
	append-cppflags "$($(tc-getPKG_CONFIG) --cflags ncurses)"
	append-libs "$($(tc-getPKG_CONFIG) --libs ncurses)"

	tc-export CC
}

src_install() {
	emake install INSTALLDIR="${D}" USRLIBDIR="/usr/$(get_libdir)"
}

src_test() {
	cd kernel_test || die
	emake
	./testall.sh || die
}

pkg_postinst() {
	elog "Execute the following command to setup the initial policy configuration:"
	elog
	elog "emerge --config =${CATEGORY}/${PF}"
	elog
	elog "For more information, please visit http://tomoyo.sourceforge.jp/1.8/"
	elog
	elog "This tools are for ccs-patch'ed kernels. There are also sys-apps/tomoyo-tools"
	elog "which works with TOMOYO 2.x.x versions (already merged into Linux kernel)."
	elog "If you'd like to try them, please emerge sys-apps/tomoyo-tools instead."
}

pkg_config() {
	"${EPREFIX}"/usr/$(get_libdir)/ccs/init_policy
}
