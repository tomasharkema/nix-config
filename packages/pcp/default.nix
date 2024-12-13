{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  bintools,
  autoreconfHook,
  libtool,
  gettext,
  python3,
  autoconf,
  automake,
  nettools,
  clang,
  binutils,
  gnused,
  coreutils,
  libsForQt5,
  bzip2,
  gzip,
  gnutar,
  libsystemtap,
  arocc,
  flex,
  bison,
  gnumake,
}:
stdenv.mkDerivation rec {
  pname = "pcp";
  version = "6.3.2";

  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    rev = version;
    hash = "sha256-FqTsOk09KEF+2kGKLJV14+CuvT8YTlXCeTOaA1LoKak=";
  };

  nativeBuildInputs = [
    pkg-config
    # bintools
    # autoreconf/Hook
    # autoconf
    gettext
    # automake
    libtool
    libsForQt5.full
    arocc
  ];

  buildInputs = [
    clang
    which
    libtool
    bintools
    arocc
    libsForQt5.full
    libsystemtap
    # bintools
    # libtool
    # autoreconfHook
    gettext
    nettools
  ];

  # bintools = binutils.bintools;

  configureFlags = [
    "--prefix=/usr"
    "--libexecdir=/usr/lib"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-rcdir=/etc/init.d"
    "--with-sysconfigdir=/etc/default"
    "--with-zip=${gzip}/bin/gzip"
    "--with-tar=${gnutar}/bin/tar"
    "SED=${gnused}/bin/sed"
    "ECHO=${coreutils}/bin/echo"
    "QMAKE=${libsForQt5.full}/bin/qmake"
    "MAKEDEPEND=/bin/true"
    "BZIP2=${bzip2}/bin/bzip2"
    "AR=${bintools}/bin/ar"
    "LEX=${flex}/bin/flex"
    "YACC=${bison}/bin/yacc"
    "MAKE=${gnumake}/bin/make"
  ];

  meta = with lib; {
    description = "Performance Co-Pilot";
    homepage = "https://github.com/performancecopilot/pcp";
    changelog = "https://github.com/performancecopilot/pcp/blob/${src.rev}/CHANGELOG";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "pcp";
    platforms = platforms.all;
  };
}
