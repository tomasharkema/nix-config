{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "14";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-BeaizSc+95YRNH8Hv0Pkjj6YJNvDkaE9Qi/0b7vfrnQ=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
