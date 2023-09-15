# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="User-mode networking daemons for virtual machines and namespaces"
HOMEPAGE="https://passt.top"
KEYWORDS=""
EGIT_REPO_URI="https://passt.top/passt"

LICENSE="GPL-2+ BSD"
SLOT="0"

DEPEND=""
RDEPEND=""
BDEPEND=""

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix=/usr \
		install
}
