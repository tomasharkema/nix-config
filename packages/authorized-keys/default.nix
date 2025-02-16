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
    sha256 = "sha256-teJq7w9HIgsJL3WGdP809dx4+oEsOISbsmsAEj8XwR4=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
