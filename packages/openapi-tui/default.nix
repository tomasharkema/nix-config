{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  oniguruma,
  openssl,
  zlib,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "openapi-tui";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "zaghaghi";
    repo = "openapi-tui";
    rev = version;
    hash = "sha256-EUWL16cHgPF88CoCD9sqnxLOlmWoe1tu5ps01AYwwzc=";
  };

  cargoHash = "sha256-sINwuMgBbc/Xn73Gy+Wwb0QtIHGGB02fVyz/K/tg5Ys=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      oniguruma
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = with lib; {
    description = "Terminal UI to list, browse and run APIs defined with openapi spec";
    homepage = "https://github.com/zaghaghi/openapi-tui";
    license = licenses.mit;
    maintainers = with maintainers; [];
    mainProgram = "openapi-tui";
  };
}
