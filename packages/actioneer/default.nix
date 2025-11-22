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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "makoni";
    repo = "actioneer-gtk";
    rev = version;
    hash = "sha256-Gm2irsHU1bLTFQH1sp4wQ8D4SreEzZEpP1yeZyAZTAA=";
  };

  cargoHash = "sha256-17ji6eWarzT9//9+xMbaHCy3/T9okQ/gs6g1huM6vhM=";

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
