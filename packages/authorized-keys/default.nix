{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "13";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-o8QjsFFatsdKEIYJlMudqxVNNkk8O6apVgv9HrUUlz0=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    cp ${src} $out

    runHook postInstall
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
