{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "15";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-ZEgB9eXH1KCcct7P6DXt8OQcPcA+FWjQYVovfKICGc8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
