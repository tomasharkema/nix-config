{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "pumas";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "graelo";
    repo = "pumas";
    rev = "v${version}";
    hash = "sha256-dFzfkAW8vnhIOF839/9WGZEK0U5/zF4q1gQ2RLRuGVU=";
  };

  cargoHash = "sha256-XYxtnO8uRDNf6V3fS9U7Vok4BeH/kZqL0vSsMmFNYhI=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.IOKit
  ];

  meta = with lib; {
    description = "Power Usage Monitor for Apple Silicon";
    homepage = "https://github.com/graelo/pumas";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "pumas";
  };
}
