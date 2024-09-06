{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustfmt,
  lib,
  stdenv,
  darwin,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "ztui";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "erikh";
    repo = "ztui";
    rev = "v${version}";
    hash = "sha256-ZbfV0AGeLgYS4S55YVBPdYFahi1sAeDrcKmiGaHAeC4=";
  };

  # patches = [
  #   ./ztui-patch.patch
  # ];

  cargoHash = "sha256-TJchVYBdrah/ExQfMHsMHbnlDviPbZYnY3WDryU5GS8=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl rustfmt] ++ (lib.optional stdenv.isDarwin darwin.Security);

  RUSTFMT = "${rustfmt}/bin/rustfmt";
  OPENSSL_NO_VENDOR = 1;
  RUSTC_BOOTSTRAP = 1;

  meta = {
    homepage = "https://github.com/erikh/ztui";
  };

  passthru = {
    updateScript = nix-update-script {};
  };
}
