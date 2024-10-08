# https://download.swift.org/swift-6.0-release/fedora39/swift-6.0-RELEASE/swift-6.0-RELEASE-fedora39.tar.gz
{
  lib,
  stdenv,
  autoPatchelfHook,
  dpkg,
  makeWrapper,
  zlib,
  ncurses,
  libgcc,
  curl,
  libxml2,
  libuuid,
  python3,
  sqlite,
  # libedit,
  clang,
  glibc,
  libbsd,
  libedit,
  # cctools,
  # webkitgtk,
  # gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "swift";
  version = "6.0.1";

  src = fetchTarball {
    url = "https://download.swift.org/swift-${version}-release/fedora39/swift-${version}-RELEASE/swift-${version}-RELEASE-fedora39.tar.gz";
    sha256 = "sha256:1f01jcmdrq3mgy7g5wvc9y8fpr5ksby2p16d0kbm2sm541mimw5n";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  buildInputs = [
    zlib
    ncurses
    clang
    libgcc
    glibc
    # stdenv.cc.cc.lib
    curl
    libxml2
    libuuid
    python3
    sqlite
    libedit
    # cctools
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out

    runHook postInstall
  '';

  # postFixup = ''
  #   wrapProgram $out/bin/swift-frontend \
  #       --prefix PATH : ${lib.makeBinPath runtimeDeps}
  #   wrapProgram $out/bin/swift-driver \
  #       --prefix PATH : ${lib.makeBinPath runtimeDeps}
  # '';
}
