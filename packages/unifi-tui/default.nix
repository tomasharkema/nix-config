{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "unifi-tui";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "callumteesdale";
    repo = "unifi-tui";
    rev = "v${version}";
    hash = "sha256-Oy9DJy5wTcc6QaMcci+lQVsmU/yGYi+KqDlIukyYA1E=";
  };

  cargoHash = "sha256-+D0g8EuhLEE3Rz+4qSRREuFnaYyuuElCYlq6EwANxcY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.isDarwin [
      # darwin.apple_sdk.frameworks.Security
      # darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = {
    description = "";
    homepage = "https://github.com/callumteesdale/unifi-tui";
    changelog = "https://github.com/callumteesdale/unifi-tui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "unifi-tui";
  };
}
