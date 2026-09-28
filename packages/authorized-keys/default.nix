{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "16";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-xWQ7FQtINzicAjkKPTB6OKbOyz1EGgDf3A5ZLugvkgY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
