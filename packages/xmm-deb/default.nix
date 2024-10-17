{
  lib,
  stdenv,
  dpkg,
  tree,
  autoPatchelfHook,
  brscan5,
  sane-backends,
  fetchurl,
}:
stdenv.mkDerivation rec {
  pname = "L850";
  version = "6.1.0.7";

  src = fetchurl {
    url = "https://dl.dell.com/FOLDER05569884M/1/L850_vV${version}_Linux.deb";
    sha256 = "";
  };

  nativeBuildInputs = [dpkg autoPatchelfHook];
  buildInputs = [];
}
