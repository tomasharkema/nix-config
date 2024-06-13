# https://downloadmirror.intel.com/822666/Preboot.tar.gz

{ stdenv, autoPatchelfHook, dpkg, makeWrapper, zlib, webkitgtk, gitUpdater, }:
stdenv.mkDerivation rec {
  pname = "iqvlinux";
  version = "0.0.1";

  src = fetchTarball {
    url = "https://downloadmirror.intel.com/822666/Preboot.tar.gz";
    sha256 = "sha256:0dxn5671yabrb2a60n2baxsf340qm5acgfcsr5nw994lilfsf16r";
  };
}
