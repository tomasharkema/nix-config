{
  dpkg,
  lib,
  stdenv,
  fetchurl,
  tree,
}:
stdenv.mkDerivation rec {
  pname = "brother-mfc2710dw-ppd";
  version = "4.0.0";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103526/mfcl2710dwpdrv-4.0.0-1.i386.deb";
    sha256 = "0b4vhq3np75nxi19ravpvlqfhrhvdbh354shscj0xixj5dnfzr1q";
  };

  nativeBuildInputs = [
    dpkg
    tree
  ];

  installPhase = ''
    mkdir -p $out/share/cups/MFCL2710DW
    cp opt/brother/Printers/MFCL2710DW/cupswrapper/brother-MFCL2710DW-cups-en.ppd $out/share/cups/MFCL2710DW
  '';
}
