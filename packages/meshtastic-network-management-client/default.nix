{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  nodePackages,
  cargo-tauri,
  pnpm_9,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meshtastic-network-management-client";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "network-management-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kFTBzd1Yzmbzekclknjqf6/Ul0FjGb8akEoVtRbqGks=";
    fetchSubmodules = true;
  };

  # cargoHash = "sha256-NFDSEc370KjUhrSimuzaAju6Eokp/fifzeW1Uk7wVWU=";

  cargoLock = {
    lockFile = "${finalAttrs.src}/src-tauri/Cargo.lock";
    outputHashes = {
      "meshtastic-0.1.6" = "sha256-erpC1O2Y6nx6ed0DQNAm7sK/TG9AZxmr6l0KJhNofGk=";
      "specta-1.0.3" = "sha256-UZ94sJJkHSAqDry6xwYhHZANLveAEpwNu/HHiAPSFJY=";
    };
  };
  cargoRoot = "src-tauri";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit
      (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 2;
    hash = "sha256-fuqQRAdTzwssk05LHncNTxkgb1dKmFxwGIOFgg+m3WA=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    #wrapGAppsHook3
    pnpm_9.configHook
    nodejs
  ];

  # buildAndTestSubdir = finalAttrs.cargoRoot;

  meta = {
    description = "A Meshtastic desktop client, allowing simple, offline deployment and administration of an ad-hoc mesh communication network. Built in Rust and TypeScript";
    homepage = "https://github.com/meshtastic/network-management-client";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [];
    mainProgram = "network-management-client";
    platforms = lib.platforms.all;
  };
})
