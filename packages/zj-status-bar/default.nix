{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  protobuf,
  openssl,
  zlib,
  stdenv,
  darwin,
  zellij,
}:
rustPlatform.buildRustPackage rec {
  pname = "zj-status-bar";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cristiand391";
    repo = "zj-status-bar";
    rev = version;
    hash = "sha256-mIXoCep3L/A9hPSPClINUxjTaVAT+N65pQP3V+Wl4gc=";
  };

  cargoHash = "sha256-+l0PmhuUgaYX3nNkj8bmglUf0hIICDn9lNMnJ2TygFk=";

  nativeBuildInputs = [
    curl
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      zellij
      curl
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Compact status-bar plugin for zellij";
    homepage = "https://github.com/cristiand391/zj-status-bar";
    changelog = "https://github.com/cristiand391/zj-status-bar/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "zj-status-bar";
  };
}
