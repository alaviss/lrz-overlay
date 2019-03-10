# Copyright 2019 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit bash-completion-r1 git-r3 multiprocessing

DESCRIPTION="A package manager for the Nim programming language."
HOMEPAGE="https://github.com/nim-lang/nimble"
KEYWORDS=""
SLOT=0
LICENSE="BSD MIT"
IUSE="debug"
EGIT_REPO_URI="https://github.com/nim-lang/nimble.git"

RDEPEND="dev-lang/nim:="
DEPEND="$RDEPEND"

nim_use_define() {
  [[ $# < 1 ]] && die "nim_use_define <useflag> [define if true]"
  local defineIfTrue="${2:-$1}"
  usex "$1" -d:"$defineIfTrue" ""
}

src_compile() {
  mkdir -p build || die "unable to create 'build' directory"
  nim c -o:build/nimble --nimcache:build/nimcache \
    $(nim_use_define !debug release) --parallel_build:$(makeopts_jobs) \
    src/nimble.nim || die "building nimble failed"
}

src_install() {
  dobin build/nimble

  newbashcomp nimble.bash-completion nimble

  insinto /usr/share/zsh/site-functions
  newins nimble.zsh-completion _nimble

  local nimbleVersion=$(git rev-parse --short HEAD)
  [[ -z $nimbleVersion ]] && die "unable to determine nimble version"
  local nimblePkgDir=/usr/share/nimble/pkgs/nimble-\#$nimbleVersion
  insinto "$nimblePkgDir"
  doins nimble.nimble
  insinto "$nimblePkgDir"
  doins -r src/*
}
