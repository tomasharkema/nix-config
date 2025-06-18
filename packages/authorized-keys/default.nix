{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "12";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-fsx70LgiO91qoBkKxyB4MLN9OiKfk1/yP1DklalpmT8=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
