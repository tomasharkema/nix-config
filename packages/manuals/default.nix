{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  libadwaita,
  flatpak,
  libff,
  cmake,
  libfoundry,
  libpeas,
  libdex,
  libpanel,
  desktop-file-utils,
  glib,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "manuals";
  version = "49.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "manuals";
    rev = version;
    hash = "sha256-h/Xphff08MmdNd4Z05TbbPYiJKdY/GkC0tR3acO0F/A=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    desktop-file-utils
    glib
    wrapGAppsHook3
  ];

  buildInputs = [
    libadwaita
    flatpak
    libff
    libfoundry
    libpeas
    libdex
    libpanel
  ];

  meta = {
    description = "";
    homepage = "https://gitlab.gnome.org/GNOME/manuals";
    changelog = "https://gitlab.gnome.org/GNOME/manuals/-/blob/${src.rev}/NEWS";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "manuals";
    platforms = lib.platforms.all;
  };
}
