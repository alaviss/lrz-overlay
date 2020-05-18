# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="CaitSith Linux userspace tools"
HOMEPAGE="https://caitsith.osdn.jp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

SRC_URI="https://osdn.net/dl/caitsith/caitsith-tools-${PV/_p/-}.tar.gz"

COMMON_DEPEND="sys-libs/ncurses:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${PN}"

src_install() {
  emake install INSTALLDIR="${ED}" USRLIBDIR="/usr/$(get_libdir)"
}
