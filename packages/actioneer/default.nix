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
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "makoni";
    repo = "actioneer-gtk";
    rev = version;
    hash = "sha256-quLy+1UG9RPbzwwbS8RCKrL2qzI+VNoXRB02Wo/FAJY=";
  };

  cargoHash = "sha256-9rIYfrS8w2iXS66UhvD7LtsJtjQByWnjmXHV4yFM2NQ=";

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
