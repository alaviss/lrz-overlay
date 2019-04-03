# Copyright 2018 kuzetsa℠ and others
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://kernel.kolivas.org/"

IUSE="experimental"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="6"
K_SECURITY_UNSUPPORTED="1"
K_PREPATCHED="1"

inherit kernel-2
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Gentoo's genpatches for Linux ${K_BRANCH_ID}, with Con Kolivas' ${EXTRAVERSION} patchset."

CK_FILE="${K_BRANCH_ID}${EXTRAVERSION}-broken-out.tar.xz"
CK_BASE_URL="http://ck.kolivas.org/patches/${KV_MAJOR}.0"

# clearly identify package name in distdir
CK_DISTNAME="${PN}-${K_BRANCH_ID}${EXTRAVERSION}.tar.xz"

CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}${EXTRAVERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE} -> ${CK_DISTNAME}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_URI}"

CK_SERIES=(
	0001-MultiQueue-Skiplist-Scheduler-version-v0.190.patch
	0002-Fix-Werror-build-failure-in-tools.patch
	0003-Make-preemptible-kernel-default.patch
	0004-Expose-vmsplit-for-our-poor-32-bit-users.patch
	0005-Create-highres-timeout-variants-of-schedule_timeout-.patch
	0006-Special-case-calls-of-schedule_timeout-1-to-use-the-.patch
	0007-Convert-msleep-to-use-hrtimers-when-active.patch
	0008-Replace-all-schedule-timeout-1-with-schedule_min_hrt.patch
	0009-Replace-all-calls-to-schedule_timeout_interruptible-.patch
	0010-Replace-all-calls-to-schedule_timeout_uninterruptibl.patch
	0011-Don-t-use-hrtimer-overlay-when-pm_freezing-since-som.patch
	0012-Make-hrtimer-granularity-and-minimum-hrtimeout-confi.patch
	0013-Make-threaded-IRQs-optionally-the-default-which-can-.patch
	0014-Reinstate-default-Hz-of-100-in-combination-with-MuQS.patch
	0015-Swap-sucks.patch
)
UNIPATCH_LIST="
  ${CK_SERIES[@]/#/$WORKDIR/ck-patches/}
"
UNIPATCH_STRICTORDER="yes"

src_unpack() {
	cd "${WORKDIR}"
	unpack "${CK_DISTNAME}"
	mv {,ck-}patches
	kernel-2_src_unpack
}
