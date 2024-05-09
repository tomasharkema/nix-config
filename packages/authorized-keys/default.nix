{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized_keys";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-YJLSHQN5TotsCLHRX35VzemFZ1kYMAfJkfH89EZyptU=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
