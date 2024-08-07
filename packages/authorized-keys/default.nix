{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.7";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "0jrv46pdjvgpi19nh2px0522r7cnf722xzh7zfvqij2gzpmw35dl";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
