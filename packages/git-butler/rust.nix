{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  cargo,
  gcc,
  perl,
  webkitgtk,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "git-butler";
  version = "0.10.28";
  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    rev = "release%2F${version}";
    hash = "sha256-j1ioqLcYxrBni8siO5DXLLPCQawAzzZgDumKizPhh1Y=";
  };
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "tauri-plugin-context-menu-0.7.0" = "sha256-/4eWzZwQtvw+XYTUHPimB4qNAujkKixyo8WNbREAZg8=";
      "tauri-plugin-log-0.0.0" = "sha256-uOPFpWz715jT8zl9E6cF+tIsthqv4x9qx/z3dJKVtbw=";
    };
  };
  OPENSSL_NO_VENDOR = 1;
  RUSTC_BOOTSTRAP = 1;
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs =
    [
      # ncurses
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.Security
      darwin.apple_sdk.frameworks.Carbon
    ]
    ++ lib.optionals stdenv.isLinux [
      openssl
      webkitgtk
    ];
}
