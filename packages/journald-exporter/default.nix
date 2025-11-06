{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "journald-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dead-claudia";
    repo = "journald-exporter";
    rev = "v${version}";
    hash = "sha256-x31f76GJuvqDmBlCcoqohyRU0nhIVs4We1zawfGrl6E=";
  };

  cargoHash = "sha256-oWSNV1ZUVRZkpEgJFBvYBNJdquofLgOj2Xbtc5jQkX4=";

  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [systemd]
    ++ (lib.optionals stdenv.isDarwin [
      # darwin.apple_sdk.frameworks.CoreFoundation
      # darwin.apple_sdk.frameworks.CoreServices
    ]);

  meta = with lib; {
    description = "A Prometheus exporter for systemd-journald";
    homepage = "https://github.com/dead-claudia/journald-exporter";
    license = licenses.unfree; # FIXME: nix-init did not found a license
    maintainers = with maintainers; [];
    mainProgram = "journald-exporter";
  };
}
