{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.2";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-d/hbf/9/WKKgkIdTxcuB7S8FO/3KudhXOuoHU5xjuOA=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
