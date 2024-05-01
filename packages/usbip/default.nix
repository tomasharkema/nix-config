{
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  rustfmt,
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  libusb1,
  hidapi,
}:
# https://github.com/jiegec/usbip/tags
rustPlatform.buildRustPackage rec {
  pname = "usbip";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "jiegec";
    repo = "usbip";
    rev = "v${version}";
    hash = "sha256-XUUgmI7qX3016QT9oZ0GHc1fT4lsCcGVjfP9q53zlwY=";
  };
  cargoPatches = [./cargo-lock.patch];
  cargoSha256 = "sha256-TVyhQmkYdw4LHlAlpw6mbK30upjEgc7vN0gfU7saLcQ=";

  RUST_BACKTRACE = 1;
  PKG_CONFIG_ALLOW_CROSS = 1;

  nativeBuildInputs = [pkg-config];
  buildInputs = [libusb1 hidapi];
}
