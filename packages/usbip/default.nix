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
  cargoLock = {
    lockFile = ./Cargo.lock;
  };
}
