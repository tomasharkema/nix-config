{
  stdenv,
  fetchurl,
  cups,
  dpkg,
}:
stdenv.mkDerivation (
  finalAttrs: {
    pname = "brother-ql700-ppd";
    version = "3.1.5-0";

    src = fetchurl {
      url = "https://download.brother.com/welcome/dlfp002192/ql700pdrv-${finalAttrs.version}.i386.deb";
      sha256 = "sha256-/4AG/Dkb9FHOCsfRyF8Qy8LImG1arC4ksZTyC/Gjp8k=";
    };

    nativeBuildInputs = [
      dpkg
    ];

    buildInputs = [
      cups
    ];

    postInstall = ''
      install -D opt/brother/PTouch/ql700/cupswrapper/brother_ql700_printer_en.ppd $out/share/cups/model/QL-700/brother_ql700_printer_en.ppd
      install -D opt/brother/PTouch/ql700/cupswrapper/brother_lpdwrapper_ql700 $out/share/cups/model/QL-700/brother_lpdwrapper_ql700
      install -D opt/brother/PTouch/ql700/cupswrapper/cupswrapperql700 $out/share/cups/model/QL-700/cupswrapperql700
    '';
  }
)
