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
  wrapGAppsHook3,
  blueprint-compiler,
}:
stdenv.mkDerivation rec {
  pname = "butler";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "butler";
    rev = version;
    hash = "sha256-Dwnnc9fMLHFWuAVjhLfCgt+yYdDku0nPTt0cADwJ9gA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    blueprint-compiler
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
