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
}:
rustPlatform.buildRustPackage rec {
  pname = "sysd-manager";
  version = "1.1.1";
  # pyproject = true;

  src = fetchFromGitHub {
    owner = "plrigaux";
    repo = "sysd-manager";
    rev = "v${version}";
    hash = "sha256-cW0IFse0GA7S4ilGbAm2eawiO9KY9GwRE/b1/nH3Ano=";
  };

  cargoLock = {lockFile = ./Cargo.lock;};

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

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
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
  ];

  # propagatedBuildInputs = with python3.pkgs; [
  #   aiohttp
  # ];

  # pythonImportsCheck = [ "sysd_manager" ];

  meta = with lib; {
    description = "";
    homepage = "https://github.com/plrigaux/sysd-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [];
    mainProgram = "sysd-manager";
  };
}
