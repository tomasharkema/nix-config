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
  gtksourceview5,
}:
rustPlatform.buildRustPackage rec {
  pname = "sysd-manager";
  version = "1.15.1";
  # pyproject = true;

  src = fetchFromGitHub {
    owner = "plrigaux";
    repo = "sysd-manager";
    rev = "v${version}";
    hash = "sha256-iV1cxZ1PludRo2zlAXQTu1CQJ5hdrm2YNi/5s+aa2Io=";
  };
  doCheck = false;
  #cargoLock = {lockFile = ./Cargo.lock;};
  cargoHash = "sha256-Ys3nvHX0F7nJikVwd0anB2fcfwcHdvdZ1Ww2lemy/GM=";
  #postPatch = ''
  #  ln -s ${./Cargo.lock} Cargo.lock
  #'';

  nativeBuildInputs = [
    cargo
    pkg-config
    python3.pkgs.setuptools
    python3.pkgs.wheel
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    tree
    systemd
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    gtksourceview5
  ];

  # propagatedBuildInputs = with python3.pkgs; [
  #   aiohttp
  # ];

  # pythonImportsCheck = [ "sysd_manager" ];

  postInstall = ''
    mkdir -p $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas
    cp -r data/* $out/share/
    mv $out/share/schemas $out/share/gsettings-schemas/${pname}-${version}/glib-2.0/schemas

    # sleep 1000
  '';

  meta = with lib; {
    description = "";
    homepage = "https://github.com/plrigaux/sysd-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "sysd-manager";
  };
}
