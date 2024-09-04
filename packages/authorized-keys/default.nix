{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "10";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-rdBwW0NFTakOjNe5voGLc6xVrNYZvVaWHaN54/Hw4aA=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
