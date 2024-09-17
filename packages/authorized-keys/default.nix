{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "11";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-GZGUqyn2ABV+ctjs3x+Nh+TXqZOAkopd20uwYNGs/Es=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
