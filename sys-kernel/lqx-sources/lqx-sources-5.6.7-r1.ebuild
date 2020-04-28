# Copyright 2018 kuzetsa℠ and others
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64"

HOMEPAGE="https://liquorix.net"

IUSE="experimental"

K_SECURITY_UNSUPPORTED="1"
K_PREPATCHED="1"

inherit kernel-2
inherit git-r3
detect_version
detect_arch

DESCRIPTION="Liquorix is a distro kernel replacement built using the best \
configuration and kernel sources for desktop, multimedia, and gaming workloads."

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"
K_LIQUORIX_VER="1"

EGIT_REPO_URI="https://github.com/damentz/liquorix-package.git"
EGIT_COMMIT="${K_BRANCH_ID}-${K_LIQUORIX_VER}"
EGIT_CHECKOUT_DIR="${WORKDIR}/lqx"
SRC_URI="${KERNEL_BASE_URI}/linux-${K_BRANCH_ID}.tar.xz"

UNIPATCH_LIST_DEFAULT=
UNIPATCH_LIST="${WORKDIR}/lqx/linux-liquorix/debian/patches/zen/v${KV}.patch"
UNIPATCH_STRICTORDER="yes"

K_EXTRAEINFO="The default liquorix configuration has been installed as
${EROOT}usr/src/linux-${KV_FULL}/config-arch-64"

src_unpack() {
	cd "${WORKDIR}"
	git-r3_src_unpack
	kernel-2_src_unpack
}

src_prepare() {
	kernel-2_src_prepare

	eapply_user
}

src_install() {
	kernel-2_src_install

	insinto /usr/src/linux-${KV_FULL}
	doins "${WORKDIR}/lqx/linux-liquorix/debian/config/kernelarch-x86/config-arch-64"
}
