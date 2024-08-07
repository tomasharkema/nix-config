{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.8";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "03d669z11z8iz5mwx6yjpflvajhfhd5wwh52l03964rviz6vpcyn";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
