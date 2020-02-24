# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

EAPI=7

inherit git-r3 multiprocessing toolchain-funcs

DESRCIPTION="A programming language that focuses on efficiency, expressiveness, and elegance."
HOMEPAGE="https://nim-lang.org/"
KEYWORDS=""
SLOT=0
LICENSE="MIT"
IUSE="doc debug +linenoise"
EGIT_REPO_URI="https://github.com/nim-lang/Nim.git"

src_unpack() {
  git-r3_src_unpack

  git-r3_fetch "https://github.com/nim-lang/csources.git"
  git-r3_checkout "https://github.com/nim-lang/csources.git" "$S/csources"
}

src_prepare() {
  sed -i 's|/opt|/usr/share|' config/nim.cfg || die "unable to set nimblepath"

  default
}

boot_use_define() {
  [[ $# != 2 ]] && die "boot_use_define <useflag> <define if true>"
  usex "$1" -d:"$2" ""
}

compile_tool() {
  [[ $# != 1 ]] && die "compile_tool <path to tool>"
  local tool=$(basename "$1" ".nim")
  bin/nim c -o:"bin/$tool" \
    $(boot_use_define !debug release) \
    --parallel_build:$(makeopts_jobs) \
    "$1" || die "building '$1' failed"
}

src_compile() {
  cd csources
  emake
  cd ..

  bin/nim c --parallel_build:$(makeopts_jobs) -d:release koch || \
    die "unable to build koch"
  ./koch boot $(boot_use_define !debug release) \
    $(boot_use_define linenoise useLinenoise) \
    $(boot_use_define elibc_glibc nativeStacktrace) \
    --parallel_build:$(makeopts_jobs) \
    $(usex "!debug" "--assertions:off" "") || die "bootstrap failed"

  compile_tool nimsuggest/nimsuggest.nim
  compile_tool tools/nimgrep.nim
  compile_tool nimpretty/nimpretty.nim
  compile_tool tools/nimfind.nim
  compile_tool testament/testament.nim

  if use doc; then
    ./koch docs
  fi
}

src_install() {
  ./koch install "$PWD/fakeinstall" || die "koch install failed"

  exeinto /usr/lib/nim/bin
  for i in bin/*; do
    [[ -x "$i" ]] && doexe "$i"
  done

  insinto /usr/lib/nim
  doins -r fakeinstall/nim/lib
  doins -r fakeinstall/nim/doc

  insinto /etc/nim
  for i in fakeinstall/nim/config/*; do
    doins "$i"
  done

  local nimVersion=$(git rev-parse --short HEAD)
  [[ -z $nimVersion ]] && die "unable to determine nim compiler version"
  local compilerPkgDir=/usr/share/nimble/pkgs/compiler-\#$nimVersion
  insinto "$compilerPkgDir"
  doins -r fakeinstall/nim/compiler{,.nimble}
  dosym /usr/lib/nim/doc "$compilerPkgDir/doc"
  dosym "$compilerPkgDir/compiler" /usr/lib/nim/compiler

  if use doc; then
    dohtml -A .idx -r doc/html/*
  fi

  insinto /usr/lib/nim/tools
  doins tools/nim-gdb.py
  doins -r tools/dochack

  doenvd "$FILESDIR/10nim"
}

pkg_postinst() {
  elog "A convenience wrapper for GDB integration has been installed as /usr/bin/nim-gdb."
  if ! has_version "sys-devel/gdb[python]"; then
    elog "This wrapper requires GDB to have 'python' USE flag set."
  fi
  if ! has_version "dev-libs/boehm-gc"; then
    elog "To make use of '--gc:boehm', install 'dev-libs/boehm-gc'."
  fi
  if ! has_version "sys-devel/gcc[go]"; then
    elog "To make use of '--gc:go', install 'sys-devel/gcc' with 'go' USE flag set."
  fi
}
