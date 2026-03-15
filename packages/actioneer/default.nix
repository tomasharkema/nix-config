{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  glib,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libadwaita,
}:
rustPlatform.buildRustPackage rec {
  pname = "actioneer";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "makoni";
    repo = "actioneer-gtk";
    rev = version;
    hash = "sha256-+8oLlH2GIJBeaFm9/OkPWTCdi8ZC6vfOIZKcKM5PMhY=";
  };

  cargoHash = "sha256-dxidh2BsLKTOo/BGVbR92/Vf79e7DfskAWjjz5Rbtfs=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
    glib
    gdk-pixbuf
    gtk4
    libadwaita
  ];

  doCheck = false;

  meta = {
    description = "A native GNOME desktop client for GitHub Actions";
    homepage = "https://github.com/makoni/actioneer-gtk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "actioneer";
  };
}
