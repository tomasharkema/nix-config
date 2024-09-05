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
  nix-update-script,
}: let
  assets = fetchFromGitHub {
    owner = "zerotier";
    repo = "DesktopUI";
    rev = "cc5b7b9fea6f9552892ab5599e8bda5bc1a4b042";
    hash = "sha256-6OOZTsZMxdB+XvzNeNcY2hJ5LOmBDDsFG84Af090sR0=";
  };
in
  stdenv.mkDerivation rec {
    pname = "zerotier-ui";
    version = "1.8.4";

    src = fetchFromGitHub {
      owner = "zerotier";
      repo = "DesktopUI";
      rev = "${version}";
      hash = "sha256-OxwNskKAeBjkV15XLtzMYrNt+FQaJd2bXxoKboCRxPE=";
    };

    nativeBuildInputs = [pkg-config];

    buildInputs = [
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
      runHook preBuild

      make linux

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      mkdir -p $out/share/applications

      cp target/release/zerotier_desktop_ui $out/bin/zerotier-ui
      cp ${assets}/ZeroTierIcon.png $out/share
      cp ${assets}/zerotier-ui.desktop $out/share/applications

      runHook postInstall
    '';

    meta = with lib; {
      description = "tomas";
      homepage = "https://github.com/tomasharkema/nix-config";
      license = licenses.mit;
      maintainers = ["tomasharkema" "tomas@harkema.io"];
    };
    passthru = {
      updateScript = nix-update-script {};
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

