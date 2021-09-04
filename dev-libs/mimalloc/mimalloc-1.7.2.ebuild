# Copyright 2021 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit cmake

DESCRIPTION="A compact general purpose allocator with excellent performance"
HOMEPAGE="https://github.com/microsoft/mimalloc"
KEYWORDS="~amd64"
SLOT=0
LICENSE="MIT"
IUSE="static-libs test"
REQUIRED_USE="test? ( static-libs )"
SRC_URI="https://github.com/microsoft/mimalloc/archive/refs/tags/v$PV.tar.gz -> $P.tar.gz"

PATCHES=(
  "${FILESDIR}/gnuinstalldirs.patch"
  "${FILESDIR}/gentoo-release.patch"
)

src_configure() {
  local mycmakeargs=(
    -DMI_BUILD_STATIC=$(usex static-libs ON OFF)
    -DMI_BUILD_TESTS=$(usex test ON OFF)
    -DMI_INSTALL_TOPLEVEL=ON
  )
  cmake_src_configure
}
