{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  cairo,
  atk,
  gdk-pixbuf,
  gtkd,
  gtk3,
}:
rustPlatform.buildRustPackage rec {
  pname = "niri-taskbar";
  version = "unstable-now";

  src = fetchFromGitHub {
    owner = "lawngnome";
    repo = "niri-taskbar";
    rev = "874ed92a1711422bcaaf635c7c3316edfc6a9d31";
    hash = "sha256-P1ZD1cxlU/0s73h7qHGCbV29fsAt6r4+9X4PEZ+mOiM=";
  };

  cargoHash = "sha256-Ql9iqbbS3DY7o5/PR96c2t4VXKoS1kjZ9k3SfhNdbzE=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [
    glib
    cairo
    atk
    gdk-pixbuf
    gtk3
    gtkd
  ];
  meta = {
    description = "Niri taskbar module for Waybar";
    homepage = "https://github.com/lawngnome/niri-taskbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "niri-taskbar";
  };
}
