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
    sha256 = "sha256-KIrgSJcgklTNINaxoUzCNwpQUYp8lQ1MSf4ForrcRxk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
