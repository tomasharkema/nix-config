{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,autoreconfHook, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "unified-remote";
  version = "0.0.1";

  src = fetchurl {
    url = "https://www.unifiedremote.com/d/linux-x64-deb";
    sha256 = "WIWW7SQll7Xp8Jwk+QDucqM6TS9I/W9K+18+SDAK9Cs=";

    #downloadToTemp = true;
    #recursiveHash = true;
    #postFetch = ''
    #  mkdir $out
    #  cp $downloadedFile $out/urserver.deb
    #'';
  };

	unpackPhase = ''
    ls -la 
    ls -la $src
    cp $src unified-remote.deb
    dpkg -x unified-remote.deb unpacked
    mkdir -p $out
		cp -r unpacked/* $out/
	'';

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
 pkg-config
  ];
}
