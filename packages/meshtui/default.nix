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
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "PeterGrace";
    repo = "meshtui";
    rev = "v${version}";
    hash = "sha256-+FthVCj86nTI6R5febyqfJUPBTVKW1KcIWKmdX/YUBM=";
  };

  cargoHash = "sha256-svFpabPBC85mKg6wD1f7YjWAMSzOEgPt4TxFwMGqeO4=";

  nativeBuildInputs = [
    protobuf
  ];

  # buildInputs = lib.optionals stdenv.isDarwin [
  #   # darwin.apple_sdk.frameworks.IOKit
  # ];

  meta = {
    description = "Console text-user-interface for Meshtastic";
    homepage = "https://github.com/PeterGrace/meshtui";
    changelog = "https://github.com/PeterGrace/meshtui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "meshtui";
  };
}
