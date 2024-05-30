{ fetchurl, lib, stdenvNoCC, }:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.3";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "0cbbbcy0qqshp82hx67k8g7cpcjhq7k5mk0095jjf58b71h18z1x";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
