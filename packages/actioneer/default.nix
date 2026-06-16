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
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "makoni";
    repo = "actioneer-gtk";
    rev = version;
    hash = "sha256-Ogu7Lns7JUhwUSFeoEXsSTA3PXNOZA657mA/6+1hZOw=";
  };

  cargoHash = "sha256-VxcBkU3/NuNbCGmsyATOxtel/H/mg+0S5Gkj+2+TkXA=";

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
