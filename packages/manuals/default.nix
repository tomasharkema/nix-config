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
  libdex_1,
  libpanel,
  desktop-file-utils,
  glib,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "manuals";
  version = "49.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "manuals";
    rev = version;
    hash = "sha256-H/PLJvU6krgsNqoAr4EGxdSto0BQMt3IMAntwPB5sQw=";
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
    libdex_1
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
