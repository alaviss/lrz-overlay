# Copyright 2018 kuzetsa℠ and others
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://kernel.kolivas.org/"

IUSE="experimental"

K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="7"
K_SECURITY_UNSUPPORTED="1"

inherit kernel-2
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Gentoo's genpatches for Linux ${K_BRANCH_ID}, with Con Kolivas' -ck patchset."

CK_VERSION="1"
CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.xz"
CK_BASE_URL="http://ck.kolivas.org/patches/${KV_MAJOR}.0"

# clearly identify package name in distdir
CK_DISTNAME="${PN}-${K_BRANCH_ID}-ck${CK_VERSION}.patch.xz"

CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE} -> ${CK_DISTNAME}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_URI}"

UNIPATCH_LIST="${DISTDIR}/${CK_DISTNAME}"
UNIPATCH_STRICTORDER="yes"
