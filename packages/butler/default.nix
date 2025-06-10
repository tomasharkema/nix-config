{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  glib,
  pkg-config,
  gtk4,
  libadwaita,
  webkitgtk_6_0,
  desktop-file-utils,
  autoPatchelfHook,
  wrapGAppsHook,
}:
stdenv.mkDerivation rec {
  pname = "butler";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "butler";
    rev = version;
    hash = "sha256-pQKok3COASRMQq5l35UdSlCkwEmSbfu8lSCazu7YNpI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
    pkg-config
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    vala
    gtk4
    libadwaita
    webkitgtk_6_0
    desktop-file-utils
  ];

  mesonFlags = ["-Dprofile=release"];

  postInstall = ''
    ln -s $out/bin/com.cassidyjames.butler $out/bin/butler
  '';

  meta = {
    description = "Home Assistant companion app for Linux";
    homepage = "https://github.com/cassidyjames/butler";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "butler";
    platforms = lib.platforms.all;
  };
}
