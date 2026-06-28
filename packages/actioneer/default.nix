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
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "makoni";
    repo = "actioneer-gtk";
    rev = version;
    hash = "sha256-K8Soo2Ed2sM+Nh7LC0Mbkk3h2HMhUURasK2Pk1JG018=";
  };

  cargoHash = "sha256-6MuiVKIVWfWtWQzvvsy6DCS2n+H4V/OVAnwrjm3HedM=";

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
