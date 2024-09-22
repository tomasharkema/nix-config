# https://download.swift.org/swift-6.0-release/fedora39/swift-6.0-RELEASE/swift-6.0-RELEASE-fedora39.tar.gz
{
  stdenv,
  autoPatchelfHook,
  # dpkg,
  makeWrapper,
  zlib,
  ncurses,
  libgcc,
  curl,
  libxml2,
  libuuid,
  python3,
  sqlite,
  libedit,
  # webkitgtk,
  # gitUpdater,
}:
stdenv.mkDerivation rec {
  pname = "swift";
  version = "6.0";

  src = fetchTarball {
    url = "https://download.swift.org/swift-${version}-release/fedora39/swift-${version}-RELEASE/swift-${version}-RELEASE-fedora39.tar.gz";
    sha256 = "sha256:0dhf8f9p4z8wh65rqnad2qv69821mm98jh7y28279dxfdrk8dwb9";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    ncurses
    libgcc
    stdenv.cc.cc.lib
    curl
    libxml2
    libuuid
    python3
    sqlite
    libedit
  ];

  installPhase = ''
    ls -la
    # sleep 1000

    cp -r usr $out
  '';
}
