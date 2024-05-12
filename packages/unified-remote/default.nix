{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "unified-remote";
  version = "0.0.1";

  src = fetchurl {
    url = "https://www.unifiedremote.com/d/linux-x64-deb";
    sha256 = "sha256-EHlJDzVH5YcKf6mcGZ85CPYkgFNFU2aCLq6APFcCaTI=";
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      mkdir $out
      cp $downloadedFile $out/urserver.deb
    '';
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];
}
