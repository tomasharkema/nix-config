{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "0.0.6";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "14wszpgjkpxv0lqqqjza0css3wj0gqhi30wdibh8s9ypkk93m61i";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
