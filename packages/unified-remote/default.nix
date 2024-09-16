{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  autoreconfHook,
  pkg-config,
  gcc,
  libgcc,
  libcxx,
}:
stdenv.mkDerivation rec {
  pname = "unified-remote";
  version = "0.0.1";

  src = fetchurl {
    url =
      if stdenv.isx86_64
      then "https://www.unifiedremote.com/d/linux-x64-deb"
      else "https://www.unifiedremote.com/download/linux-arm64-deb";
    #"https://www.unifiedremote.com/download/linux-arm64-portable";
    sha256 =
      if stdenv.isx86_64
      then "WIWW7SQll7Xp8Jwk+QDucqM6TS9I/W9K+18+SDAK9Cs="
      else "kokM7rqXZzLvwhEezD0qcsdivjFFMzp0PhFtwKip1vM=";

    #downloadToTemp = true;
    #recursiveHash = true;
    #postFetch = ''
    #  mkdir $out
    #  cp $downloadedFile $out/urserver.deb
    #'';
  };

  unpackPhase = ''
    cp $src unified-remote.deb
    dpkg -x unified-remote.deb unpacked
    mkdir -p $out
    cp -r unpacked/* $out/
    cp -r $out/opt/urserver/ $out/bin/
    mkdir -p $out/share/applications/
    cp $out/opt/urserver/urserver-autostart.desktop $out/share/applications/
  '';

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [autoPatchelfHook dpkg makeWrapper pkg-config gcc libgcc libcxx];
}
