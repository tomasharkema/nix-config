# {
#   callPackage,
#   lib,
#   pkgs,
# }: let
#   customBuildRustCrateForPkgs = pkgs:
#     pkgs.buildRustCrate.override {
#       defaultCrateOverrides =
#         pkgs.defaultCrateOverrides
#         // {
#           # cssparser-macros = attrs: {
#           #   buildInputs =
#           #     lib.optionals
#           #     pkgs.stdenv.isDarwin
#           #     [pkgs.darwin.apple_sdk.frameworks.Security];
#           # };
#         };
#     };
#   generatedBuild = callPackage ./Cargo.nix {
#     buildRustCrateForPkgs = customBuildRustCrateForPkgs;
#   };
# in
#   generatedBuild.rootCrate.build
{
  stdenv,
  pkgs,
  lib,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  # meson,
}:
rustPlatform.buildRustPackage rec {
  pname = "zerotier-desktop";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "DesktopUI";
    rev = "${version}";
    hash = "sha256-k9RAI6ii8W+sr+wHnuiqjk4O30xemNspXU6EUNTxU/4=";
  };
  cargoVendorDir = "vendor";
  # cargoDeps = rustPlatform.fetchCargoTarball {
  #   inherit src;
  #   name = "${pname}-${version}";
  #   hash = "sha256-miW//pnOmww2i6SOGbkrAIdc/JMDT4FJLqdMFojZeoY=";
  # };

  # cargoSha256 = "";
  # cargoDepsName = pname;

  # cargoLock = rustPlatform.importCargoLock {
  #   lockFileContents = builtins.readFile "${src}/Cargo.lock";
  #   # hash = "";
  # };
  nativeBuildInputs = with pkgs; [
    meson
    pkg-config
    libsoup
  ];
  buildInputs = with pkgs; [
    # nixos-appstream-data
    glib
  ];
  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };
}
