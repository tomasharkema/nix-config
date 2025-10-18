{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "meshtui";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "PeterGrace";
    repo = "meshtui";
    rev = "v${version}";
    hash = "sha256-de0iR89+sVba8Nlrgxzw7bssX1SsrVFSPPNYyBxrWEA=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "meshtastic-0.1.6" = "sha256-8VGgXdxMxRfb+oZZV48ZpiD3z83HOs+PvzPKRWDpX40=";
    };
  };

  nativeBuildInputs = [
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
  ];

  meta = {
    description = "Console text-user-interface for Meshtastic";
    homepage = "https://github.com/PeterGrace/meshtui";
    changelog = "https://github.com/PeterGrace/meshtui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "meshtui";
  };
}
