{
  lib,
  python3,
  fetchFromGitHub,
  cargo,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  systemd,
  desktop-file-utils,
  gettext,
  gobject-introspection,
  gtksourceview5,
}:
rustPlatform.buildRustPackage rec {
  pname = "sysd-manager";
  version = "1.15.0";
  # pyproject = true;

  src = fetchFromGitHub {
    owner = "plrigaux";
    repo = "sysd-manager";
    rev = "v${version}";
    hash = "sha256-iV1cxZ1PludRo2zlAXQTu1CQJ5hdrm2YNi/5s+aa2Io=";
  };

  doCheck = false;

  cargoHash = "sha256-fFr6TFF9kbCWmgE2TgvNN9swmNPJhL//0qeHd1RXo3E=";

  nativeBuildInputs = [
    cargo
    pkg-config
    python3.pkgs.setuptools
    python3.pkgs.wheel
    rustPlatform.cargoSetupHook
    rustc
    desktop-file-utils
    gettext
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    systemd
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    gtksourceview5
  ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
    cp -r data/* $out/share/
    mv $out/share/schemas/* $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/plrigaux/sysd-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "sysd-manager";
  };
}
