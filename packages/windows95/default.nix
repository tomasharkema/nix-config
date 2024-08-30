{
  stdenv,
  fetchurl,
  rpm,
  cpio,
  autoPatchelfHook,
  ffmpeg,
  cairo,
  glib,
  nss,
  dbus,
  libdrm,
  gtk3,
  mesa,
  nspr,
  at-spi2-atk,
  cups,
  pango,
  xorg,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "windows95";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/felixrieseberg/windows95/releases/download/v${version}/windows95-${version}-1.x86_64.rpm";
    sha256 = "sha256-Tnw2rj11ZPFAR6Ba7ryW5G++xYBcDAxM8ZdZNHK87Bo= ";
  };

  unpackCmd = "rpm2cpio $curSrc | cpio -idmv";

  nativeBuildInputs = [rpm cpio autoPatchelfHook wrapGAppsHook];
  buildInputs = [
    ffmpeg
    cairo
    glib
    nss
    dbus
    libdrm
    gtk3
    mesa
    nspr
    at-spi2-atk
    cups
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];
  installPhase = ''
    cp -vr . $out
  '';
}
