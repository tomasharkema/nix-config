{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  libsoup,
  pango,
  webkitgtk,
}:
rustPlatform.buildRustPackage rec {
  pname = "whatstux";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "nexxontech";
    repo = "whatstux";
    rev = version;
    hash = "sha256-2qXqnornLA0Jtw6bmOmlQVBN2Bn+MXtyUtYHoNQfrBA=";
  };

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    libsoup
    pango
    webkitgtk
  ];

  meta = {
    description = "";
    homepage = "https://gitlab.com/nexxontech/whatstux";
    license = lib.licenses.gpl3Only;
    # maintainers = with lib.maintainers; [];
    mainProgram = "whatstux";
  };
}
