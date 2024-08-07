{
  fetchurl,
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation rec {
  pname = "authorized-keys";
  version = "9";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "04w6vdkd6hiz1l2l59scy7kn0zw5iwfd2wag8fn13zpwccrkdqig";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
