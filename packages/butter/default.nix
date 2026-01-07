{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
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
}:
stdenv.mkDerivation rec {
  pname = "butter";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "zhangyuannie";
    repo = "butter";
    rev = "v${version}";
    hash = "sha256-LI0SKrfMTcPBnDfg58ehpw7HV9csFUfa/w4SDkHkGTc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-NN2YqCzgnd4HXWbiHvz5ilqaOh2SfQwh8NeGZlM2xqI=";
  };

  nativeBuildInputs = [
    cargo
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    desktop-file-utils

    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    systemd
  ];

  meta = {
    description = "Btrfs snapshot management GUI frontend";
    homepage = "https://github.com/zhangyuannie/butter";
    changelog = "https://github.com/zhangyuannie/butter/blob/${src.rev}/RELEASES.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "butter";
    platforms = lib.platforms.all;
  };
}
