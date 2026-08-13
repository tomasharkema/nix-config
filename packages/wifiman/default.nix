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
  wrapGAppsHook3,
  copyDesktopItems,
  pkg-config,
  libayatana-appindicator,
  lib,
}:
stdenv.mkDerivation (
  finalAttrs: {
    pname = "wifiman-desktop";
    version = "1.2.8";

    src = fetchurl {
      url = "https://desktop.wifiman.com/wifiman-desktop-${finalAttrs.version}-amd64.deb";
      sha256 = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
    };

    nativeBuildInputs = [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
      copyDesktopItems
      pkg-config
    ];

    buildInputs = [
      gtk3
      glibc
      libgcc
      webkitgtk_4_1
      glib
      gobject-introspection
      libayatana-appindicator
    ];

    postInstall = ''
      mkdir $out
      cp -va usr/* $out

      substituteInPlace $out/lib/wifiman-desktop/wifiman-desktop.service \
        --replace-fail "/usr/lib/wifiman-desktop/wifiman-desktopd" "$out/lib/wifiman-desktop/wifiman-desktopd"

      mkdir -p $out/lib/systemd/system
      mv $out/lib/wifiman-desktop/wifiman-desktop.service $out/lib/systemd/system/wifiman-desktop.service

      substituteInPlace $out/share/applications/wifiman-desktop.desktop \
        --replace-fail "Exec=wifiman-desktop" "Exec=$out/bin/wifiman-desktop"

      wrapProgram "$out/bin/wifiman-desktop" --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libayatana-appindicator]}"
    '';
  }
)
