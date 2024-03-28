{
  appimageTools,
  fetchzip,
  fetchurl,
  lib,
  stdenv,
}: let
  shortVersion = "0.10.28";
  build = "764";
  fullVersion = "${shortVersion}-${build}";
  fullArch =
    if stdenv.isx86_64
    then "x86_64"
    else "aarch64";
  arch =
    if stdenv.isx86_64
    then "amd64"
    else "aarch64";
in
  appimageTools.wrapType2 rec {
    pname = "git-butler";
    version = fullVersion;
    src = fetchurl {
      url = "https://releases.gitbutler.com/releases/release/${fullVersion}/linux/${fullArch}/git-butler_${shortVersion}_${arch}.AppImage";
      hash = "sha256-kE98uVTObtYQvlFvStVBgvwVsX05qLSkgt+sk1oaNY0=";
    };
    extraPkgs = pkgs: with pkgs; [libthai];
    extraInstallCommands = let
      contents = appimageTools.extractType2 {inherit pname version src;};
    in ''
      mkdir -p "$out/share/applications"
      cp -r ${contents}/usr/share/* "$out/share"
      ln -fns "$out/bin/${pname}-${version}" "$out/bin/${pname}"
    '';
  }
# {
#   lib,
#   stdenv,
#   fetchFromGitHub,
#   rustPlatform,
#   openssl,
#   pkg-config,
#   cargo,
#   gcc,
#   perl,
#   webkitgtk,
# }:
# rustPlatform.buildRustPackage rec {
#   pname = "git-butler";
#   version = "0.10.28";
#   src = fetchFromGitHub {
#     owner = "gitbutlerapp";
#     repo = "gitbutler";
#     rev = "release%2F${version}";
#     hash = "sha256-j1ioqLcYxrBni8siO5DXLLPCQawAzzZgDumKizPhh1Y=";
#   };
#   cargoLock = {
#     lockFile = "${src}/Cargo.lock";
#     outputHashes = {
#       "tauri-plugin-context-menu-0.7.0" = "sha256-/4eWzZwQtvw+XYTUHPimB4qNAujkKixyo8WNbREAZg8=";
#       "tauri-plugin-log-0.0.0" = "sha256-uOPFpWz715jT8zl9E6cF+tIsthqv4x9qx/z3dJKVtbw=";
#     };
#   };
#   OPENSSL_NO_VENDOR = 1;
#   RUSTC_BOOTSTRAP = 1;
#   nativeBuildInputs = [
#     pkg-config
#   ];
#   buildInputs =
#     [
#       # ncurses
#       openssl
#       webkitgtk
#     ]
#     ++ lib.optionals stdenv.isDarwin [
#       # Security
#     ];
# }

