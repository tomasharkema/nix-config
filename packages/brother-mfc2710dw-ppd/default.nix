{
  dpkg,
  lib,
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "brother-mfc2710dw-ppd";
  version = "4.0.0-1";

  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103526/mfcl2710dwpdrv-${finalAttrs.version}.i386.deb";
    sha256 = "0b4vhq3np75nxi19ravpvlqfhrhvdbh354shscj0xixj5dnfzr1q";
  };

  nativeBuildInputs = [
    dpkg
  ];

  postInstall = ''
    install -D opt/brother/Printers/MFCL2710DW/cupswrapper/brother-MFCL2710DW-cups-en.ppd $out/share/cups/model/MFCL2710DW/brother-MFCL2710DW-cups-en.ppd
  '';
})
