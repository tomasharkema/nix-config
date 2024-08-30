# https://github.com/ismet55555/bieye
{
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustfmt,
  lib,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "bieye";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "ismet55555";
    repo = "bieye";
    rev = "v${version}";
    sha256 = "sha256-cyR2O6Ei1TciWztRM9AwdaPm0pJkTZM6nQaoVXxchZg=";
  };

  cargoHash = "sha256-RTKV5EC/fYDI3uuXtuUjKrxmbx68L2M7dZxDydyb460=";
}
