{
  stdenv,
  fetchFromGitHub,
  lib,
  pkg-config,
  glib,
  libsoup,
  cairo,
  pango,
  gdk-pixbuf,
  gtk3,
  libappindicator,
  webkitgtk,
  libui,
  cargo,
  tree,
}:
stdenv.mkDerivation rec {
  pname = "zerotier_desktop_ui";
  version = "1.8.3";
  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "DesktopUI";
    rev = "${version}";
    hash = "sha256-k9RAI6ii8W+sr+wHnuiqjk4O30xemNspXU6EUNTxU/4=";
  };
  nativeBuildInputs = [
    # meson
    pkg-config
  ];
  buildInputs = [
    # nixos-appstream-data
    glib
    libsoup
    cairo
    pango
    gdk-pixbuf
    gtk3
    libappindicator
    webkitgtk
    libui
    cargo
  ];

  buildPhase = ''
    make linux
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r target/release/zerotier_desktop_ui $out/bin
  '';

  meta = with lib; {
    description = "tomas";
    homepage = "https://github.com/tomasharkema/nix-config";
    license = licenses.mit;
    maintainers = ["tomasharkema" "tomas@harkema.io"];
  };
}
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
# {
#   stdenv,
#   pkgs,
#   lib,
#   fetchFromGitHub,
#   rustPlatform,
#   cargo,
#   # meson,
# }:
# rustPlatform.buildRustPackage rec {
#   pname = "zerotier-desktop";
#   version = "1.8.3";
#   src = fetchFromGitHub {
#     owner = "zerotier";
#     repo = "DesktopUI";
#     rev = "${version}";
#     hash = "sha256-k9RAI6ii8W+sr+wHnuiqjk4O30xemNspXU6EUNTxU/4=";
#   };
#   cargoVendorDir = "vendor";
#   # cargoDeps = rustPlatform.fetchCargoTarball {
#   #   inherit src;
#   #   name = "${pname}-${version}";
#   #   hash = "sha256-miW//pnOmww2i6SOGbkrAIdc/JMDT4FJLqdMFojZeoY=";
#   # };
#   # cargoSha256 = "";
#   # cargoDepsName = pname;
#   # cargoLock = rustPlatform.importCargoLock {
#   #   lockFileContents = builtins.readFile "${src}/Cargo.lock";
#   #   # hash = "";
#   # };
#   nativeBuildInputs = with pkgs; [
#     meson
#     pkg-config
#   ];
#   buildInputs = with pkgs; [
#     # nixos-appstream-data
#     glib
#     libsoup
#     cairo
#     pango
#     gdk-pixbuf
#     gtk3
#     libappindicator
#     webkitgtk
#     libui
#   ];
#   meta = with lib; {
#     description = "tomas";
#     homepage = "https://github.com/tomasharkema/nix-config";
#     license = licenses.mit;
#     maintainers = ["tomasharkema" "tomas@harkema.io"];
#   };
# }

