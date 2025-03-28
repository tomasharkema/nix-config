{
  lib,
  rustPlatform,
  fetchFromGitHub,
}: let
  master = "4c6178c35f672d042bfb8c833f90281e95be1b95";
in
  rustPlatform.buildRustPackage rec {
    pname = "illuminanced";
    version = master; # "1.0.1";

    src = fetchFromGitHub {
      owner = "mikhail-m1";
      repo = "illuminanced";
      rev = version;
      hash = "sha256-D0nEPnb1MFMQHJMhJo1ursfsclFG+XInBtFQXs7y0qw=";
    };

    cargoHash = "sha256-ykmpH4QTvL4+Vrp8mkYxO441uMQQrZT55Dm1ofmIzsw=";

    meta = {
      description = "Ambient Light Sensor Daemon for Linux";
      homepage = "https://github.com/mikhail-m1/illuminanced";
      license = lib.licenses.gpl3Only;
      maintainers = with lib.maintainers; [];
      mainProgram = "illuminanced";
    };
  }
