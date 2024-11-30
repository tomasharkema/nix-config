{
  stdenv,
  fetchurl,
  qt5,
  openssl,
  glib,
}:
stdenv.mkDerivation {
  name = "NetatmoModulesManager";

  src = fetchurl {
    url = "https://n3twizard.blob.core.windows.net/wizard/NetatmoModulesManager_Linux_x86_64";
    sha256 = "sha256-qtcC0aawgzpnSYKWofdibOydRAtdvKEX7sV4ir7YO7Y=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];
  buildInputs = [openssl glib];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/NetatmoModulesManager
    chmod +x $out/bin/NetatmoModulesManager
  '';
}
