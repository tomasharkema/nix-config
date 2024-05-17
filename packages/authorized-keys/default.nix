{ fetchurl, lib, stdenvNoCC, }:
stdenvNoCC.mkDerivation rec {
  pname = "authorized_keys";
  version = "0.0.1";

  src = fetchurl {
    url = "https://github.com/tomasharkema.keys";
    sha256 = "sha256-o5P+hgd/zN5foeGvpbqO530fO8qM0WMuGuyDigD8ESE=";
  };

  dontUnpack = true;

  installPhase = ''
    cp ${src} $out
  '';

  passthru.keys = lib.splitString "\n" (builtins.readFile src);
}
