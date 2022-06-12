# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Unprivileged development environment"
HOMEPAGE="https://distrobox.privatedns.org/"
SRC_URI="https://github.com/89luca89/distrobox/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	./install -P "${ED}/usr"
}
