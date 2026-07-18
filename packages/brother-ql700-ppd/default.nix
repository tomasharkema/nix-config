{
  lib,
  stdenv,
  fetchurl,
  cups,
}:
stdenv.mkDerivation (
  finalAttrs: {
    pname = "brother-mfc2710dw-ppd";
    version = "3.1.5-0";

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlfp101060/cupswrapper-ql-700-src-${finalAttrs.version}.tar.gz";
      sha256 = "";
    };

    buildInputs = [
      cups
    ];

    installPhase = ''
      install -D ppd/brother_ql700_printer_en.ppd $out/share/cups/ppd/Brother
    '';
  }
)
