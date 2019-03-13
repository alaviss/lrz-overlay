# Copyright 2018 Leorize
#
# Licensed under the ISC license. For more information, please refer to the
# "license" file, included in this distribution.

# @ECLASS: uxp.eclass
# @MAINTAINER:
#   Leorize
# @AUTHOR:
#   Leorize
# @BUGREPORTS:
#   Bugs should be reported to Github/Gitlab at either:
#     - https://github.com/alaviss/lrz-overlay
#     - https://gitlab.com/leorize/lrz-overlay
# @BLURB: Common bits shared between UXP applications

WANT_AUTOCONF=2.1

inherit autotools flag-o-matic

if test "${EAPI:-0}" -ne 6; then
  die "$ECLASS: EAPI $EAPI not supported"
fi

EXPORT_FUNCTIONS src_configure src_compile src_install

# @ECLASS-VARIABLE: UXPCONF_EXTRA
# @DEFAULT-UNSET
# @DESCRIPTION:
#   Appends content of UXPCONF_EXTRA to UXP configuration. This is analogous to
#   ECONF_EXTRA.
#
#   Meant to be set by the user.
UXPCONF_EXTRA="${UXPCONF_EXTRA}"

# @ECLASS-VARIABLE: UXPUSE
# @INTERNAL
# @DESCRIPTION:
#   Contains USE flags that can be mapped into UXP config.
UXPUSE="accessibility alsa av1 debug dbus eme ffmpeg gconf gps jack +jemalloc
        libproxy raw pulseaudio startup-notification system-bz2
        system-cairo system-ffi system-jpeg system-hunspell
        system-icu system-libevent system-libvpx system-nspr
        system-nss system-pixman system-png system-sqlite
        system-zlib webrtc wifi"

IUSE="$IUSE $UXPUSE custom-optimization"

# @ECLASS-VARIABLE: COMMON_DEPEND
# @INTERNAL
# @DESCRIPTION: Contains libraries that must present at build time and runtime
COMMON_DEPEND="accessibility? ( dev-libs/atk )
               alsa? ( media-libs/alsa-lib )
               dbus? (
                 >=dev-libs/dbus-glib-0.60
                 >=sys-apps/dbus-0.60
               )
               >=dev-libs/glib-2.22
               gps? ( >=sci-geosciences/gpsd-3.11 )
               libproxy? ( net-libs/libproxy )
               >=media-libs/fontconfig-2.7.0
               media-libs/freetype:2
               pulseaudio? ( media-sound/pulseaudio )
               startup-notification? ( >=x11-libs/startup-notification-0.8 )
               system-bz2? ( app-arch/bzip2 )
               system-cairo? ( >=x11-libs/cairo-1.10[X] )
               system-ffi? ( >dev-libs/libffi-3.0.9 )
               system-jpeg? ( >=media-libs/libjpeg-turbo-1.3.0 )
               system-hunspell? ( app-text/hunspell )
               system-icu? ( >=dev-libs/icu-58.1 )
               system-libevent? ( dev-libs/libevent )
               system-png? ( >=media-libs/libpng-1.6.25[apng] )
               system-libvpx? ( >=media-libs/libvpx-1.5.0 )
               system-nspr? ( >=dev-libs/nspr-4.13.1 )
               system-nss? ( >=dev-libs/nss-3.38 )
               system-pixman? ( >=x11-libs/pixman-0.19.2 )
               system-sqlite? ( >=dev-db/sqlite-3.26.0[secure-delete] )
               system-zlib? ( >=sys-libs/zlib-1.2.3 )
               >=x11-libs/gtk+-2.18.0:2
               x11-libs/libX11
               x11-libs/libxcb
               x11-libs/libXext
               x11-libs/libXScrnSaver
               x11-libs/libXt
               >=x11-libs/pango-1.22.0
               webrtc? (
                 x11-libs/libXcomposite
                 x11-libs/libXdamage
                 x11-libs/libXfixes
               )"
DEPEND="app-arch/unzip
        app-arch/zip
        dev-lang/python:2.7=
        !system-jpeg? (
          x86? ( >=dev-lang/yasm-1.0.1 )
          amd64? ( >=dev-lang/yasm-1.0.1 )
        )
        !system-libvpx? (
          x86? ( dev-lang/yasm )
          amd64? ( dev-lang/yasm )
        )
        sys-apps/findutils
        $COMMON_DEPEND"

RDEPEND="$COMMON_DEPEND
         ffmpeg? ( || (
                        media-video/ffmpeg:0/55.57.57
                        media-video/ffmpeg:0/56.58.58
                      )
                  )
         wifi? ( net-misc/networkmanager )"
REQUIRED_USE="system-cairo? ( system-pixman )
              wifi? ( dbus )
              || ( alsa pulseaudio )"

# @FUNCTION: uxpconfig_add_line
# @USAGE: uxpconfig_add_line <line>
# @DESCRIPTION: Add `<line>` to the configuration file.
uxpconfig_add_line() {
  local -r line="$1"
  [[ -e .mozconfig ]] || die "UXP configuration file not found"
  echo "$line" >> .mozconfig
}

# @FUNCTION: uxpconfig_add_ac
# @USAGE: uxpconfig_add_ac <configure option>
# @DESCRIPTION: Add configure option to the configuration file.
uxpconfig_add_ac() {
  local -r opt="$1"

  [[ -z $opt ]] && die "Requires an option to be passed"

  uxpconfig_add_line "ac_add_options $opt"
}

# @FUNCTION: uxpconfig_init
# @USAGE: uxpconfig_init <application>
# @DESCRIPTION:
#   Initialize the configuration file for `<application>`.
#   This function should be called before any other
uxpconfig_init() {
  local -r app="$1"

  [[ -z $app ]] && die "An application name has to be passed"

  : > .mozconfig
  uxpconfig_add_ac "--enable-application=\"$app\""
}

# @FUNCTION: uxpconfig_use_enable
# @USAGE: uxpconfig_use_enable <USE> [config-name]
# @DESCRIPTION:
#   Appends --{en,dis}able-USE to the build configuration, depends on the status
#   of the USE flag. This is the `use_enable()` for uxp applications.
#
#   If `config-name` is provided, then --{en,dis}able-config-name will be
#   appended instead.
#
#   Requires configuration file to be initialized beforehand.
uxpconfig_use_enable() {
  local -r flag="$1"
  local -r confname="$2"

  [[ -z $flag ]] && die "An USE flag has to be passed"

  if use "$flag"; then
    uxpconfig_add_ac --enable-${confname:-$flag}
  else
    uxpconfig_add_ac --disable-${confname:-$flag}
  fi
}

# @FUNCTION: uxpconfig_use_with
# @USAGE: uxpconfig_use_with <USE> [config-name]
# @DESCRIPTION:
#   Appends --with{,out}-USE to the build configuration, depends on the status
#   of the USE flag. This is the `use_with()` for uxp applications.
#
#   If `config-name` is provided, then --with{.out}-config-name will be
#   appended instead.
#
#   Requires configuration file to be initialized beforehand.
uxpconfig_use_with() {
  local -r flag="$1"
  local -r confname="$2"

  [[ -z $flag ]] && die "An USE flag has to be passed"

  if use "$flag"; then
    uxpconfig_add_ac --with-${confname:-$flag}
  else
    uxpconfig_add_ac --without-${confname:-$flag}
  fi
}

# @FUNCTION: uxp_src_configure
# @USAGE: uxp_src_configure [application name]
# @DESCRIPTION: Configures the UXP application
uxp_src_configure() {
  local -r appname="${1:-$PN}"
  uxpconfig_init "$appname"
  for u in $UXPUSE
  do
    case $u in
      gps)
        uxpconfig_use_enable $u gpsd
        ;;
      system-cairo|system-hunspell|system-pixman|system-sqlite)
        uxpconfig_use_enable $u
        ;;
      system-*)
        uxpconfig_use_with $u
        ;;
      wifi)
        uxpconfig_use_enable $u necko-wifi
        ;;
      +*)
        uxpconfig_use_enable ${u#+}
        ;;
      -*)
        uxpconfig_use_enable ${u#-}
        ;;
      *)
        uxpconfig_use_enable $u
        ;;
    esac
  done

  if use custom-optimization; then
    uxpconfig_add_ac --enable-optimize="\"$(get-flag '-O*')\""
  else
    uxpconfig_add_ac '--enable-optimize="-O2 -msse2 -mfpmath=sse"'
  fi

  uxpconfig_add_ac --enable-default-toolkit=cairo-gtk2
  uxpconfig_add_ac --prefix="\"$EPREFIX/usr\""
  uxpconfig_add_ac --enable-pie
  uxpconfig_add_ac --disable-updater
  uxpconfig_add_ac --with-distribution-id=org.gentoo
  use debug || uxpconfig_add_ac --enable-release

  uxpconfig_add_line "mk_add_options XARGS=/usr/bin/xargs"

  uxpconfig_add_line "$UXPCONF_EXTRA"
}

# @FUNCTION: uxp_src_compile
# @USAGE: uxp_src_compile
# @DESCRIPTION: Compile the UXP application
uxp_src_compile() {
  if ! use debug; then
    append-cflags -g0
    append-cxxflags -g0
  fi
  append-ldflags '-Wl,-rpath,\$$ORIGIN'
  emake -f client.mk build
}

# @FUNCTION: uxp_src_install
# @USAGE: uxp_src_install
# @DESCRIPTION: Install the UXP application
uxp_src_install() {
  emake -f client.mk DESTDIR="$D" INSTALL_SDK= install
}
