{
  system,
  inputs,
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libsoup,
  ncurses,
  webkitgtk,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
}: let
  toolchain = inputs.fenix.packages."${system}".default.toolchain;
in
  (pkgs.makeRustPlatform {
    cargo = toolchain;
    rustc = pkgs.rustc; # toolchain;
  })
  .buildRustPackage rec {
    pname = "p-ctrl";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "MohamedSherifNoureldin";
      repo = "PCtrl";
      rev = "v${version}";
      hash = "sha256-TSI1CDSRSOGVnqPUjtSSjnJzAHGMR3s566lGemiVRCU=";
    };

    # sourceRoot = "${src.name}/src-tauri";

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    npmDeps = fetchNpmDeps {
      name = "${pname}-npm-deps-${version}";
      inherit src;
      hash = "sha256-6sw5P0ckktgI20ZPMFQf4UUEVcPFlcLptvHNMK7IzuA=";
    };

    postPatch = ''
      ln -s ${./Cargo.lock} ./Cargo.lock # ${src.name}/src-tauri/Cargo.lock
    '';

    nativeBuildInputs = [
      pkg-config
      cargo-tauri
      cargo-tauri.hook

      nodejs
      npmHooks.npmConfigHook
    ];

    buildInputs = [
      libsoup
      webkitgtk
      ncurses
    ];

    meta = with lib; {
      description = "Rust based Linux Process Manager with both a GUI and a TUI";
      homepage = "https://github.com/MohamedSherifNoureldin/PCtrl";
      license = licenses.unfree; # FIXME: nix-init did not found a license
      maintainers = with maintainers; [];
      mainProgram = "p-ctrl";
      platforms = platforms.all;
    };
  }
