{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.4";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-2aiRs0VDBe2Ksn7uPHSM2SnHOkFgnq2SDo1nOfySCpU=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
