{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "1x64f5v56pmxb68ycnp1fmpwsvyhvr49jfivfczchb1sk8gcdvfd";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
