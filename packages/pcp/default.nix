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
}:
stdenv.mkDerivation rec {
  pname = "pcp";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "performancecopilot";
    repo = "pcp";
    rev = version;
    hash = "sha256-2Gre8N8Z5CgQ2nsZOFxo+vLszGAUQIaI6bwFu8KoeRQ=";
  };

  nativeBuildInputs = [
    pkg-config
    # bintools
    # autoreconfHook
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
