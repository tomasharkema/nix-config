{
  fetchurl,
  stdenv,
  dpkg,
  autoPatchelfHook,
  glibc,
  libgcc,
  webkitgtk_4_1,
  glib,
  gobject-introspection,
  gtk3,
}:
stdenv.mkDerivation {
  pname = "wifiman-desktop";
  version = "1.2.8";
  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-1.2.8-amd64.deb";
    sha256 = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    glibc
    libgcc
    webkitgtk_4_1
    glib
    gobject-introspection
  ];

  installPhase = ''
    mkdir $out
    cp -a usr/* $out

    mv $out/lib/wifiman-desktop/* $out/lib
    mv $out/lib/wifiman-desktop/.* $out/lib

    mv $out/lib/wifiman-desktopd $out/bin/wifiman-desktopd

    substituteInPlace $out/lib/wifiman-desktop.service \
      --replace-fail "/usr/lib/wifiman-desktop/wifiman-desktopd" "$out/bin/wifiman-desktopd"

    mkdir -p $out/lib/systemd/system
    mv $out/lib/wifiman-desktop.service $out/lib/systemd/system

    substituteInPlace $out/share/applications/wifiman-desktop.desktop \
      --replace-fail "Exec=wifiman-desktop" "Exec=$out/bin/wifiman-desktop"
  '';
}
