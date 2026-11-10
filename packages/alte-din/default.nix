{
  stdenvNoCC,
  fetchzip,
  installFonts,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "alte-din-font";
  version = "unstable";

  src = fetchzip {
    url = "https://www.1001fonts.com/download/alte-din-1451-mittelschrift.zip";
    sha256 = "sha256-DTKw4zmRzZXLgQ/pfHRfmhZltLeBUxFQbze9CmHU1XQ=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    installFonts
  ];

  postInstall = ''
    installFont ttf $out/share/fonts/ttf
  '';
})
