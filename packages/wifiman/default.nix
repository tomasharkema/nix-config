{
  fetchurl,
  stdenv,
  dpkg,
  tree,
  autoPatchelfHook,
  glibc,
  libgcc,
  webkitgtk_4_0,
  glib,
  gobject-introspection,
  gtk3,
}:
stdenv.mkDerivation {
  pname = "wi-fiman-desktop";
  version = "1.1.3";
  src = fetchurl {
    url = "https://desktop.wifiman.com/wifiman-desktop-1.1.3-amd64.deb";
    sha256 = "sha256-y//hyqymtgEdrKZt3milTb4pp+TDEDQf6RehYgDnhzA=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    glibc
    libgcc
    webkitgtk_4_0
    glib
    gobject-introspection
  ];

  installPhase = ''
    mkdir $out
    cp -a usr/* $out

    substituteInPlace $out/lib/wi-fiman-desktop/wifiman-desktop.service \
      --replace-fail "/usr/lib/wi-fiman-desktop/wifiman-desktopd" "$out/lib/wi-fiman-desktop/wifiman-desktopd"

    substituteInPlace $out/share/applications/wi-fiman-desktop.desktop \
      --replace-fail "Exec=wi-fiman-desktop" "Exec=$out/bin/wi-fiman-desktop"
  '';
}
