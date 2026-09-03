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
stdenv.mkDerivation (finalAttrs: {
  pname = "butler";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "cassidyjames";
    repo = "butler";
    rev = finalAttrs.version;
    hash = "sha256-z/+UytNElAs7oUFwcBinZ5EgWsdQHGP7mlPBnCdhIGI=";
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
})
