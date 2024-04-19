# {
#   stdenv,
#   fetchFromGitHub,
#   pkg-config,
#   openssl,
#   darwin,
#   lib,
#   webkitgtk,
#   nodePackages,
# }:
# stdenv.mkDerivation rec {
#   pname = "git-butler";
#   version = "0.10.28";
#   src = fetchFromGitHub {
#     owner = "gitbutlerapp";
#     repo = "gitbutler";
#     rev = "release%2F${version}";
#     hash = "sha256-j1ioqLcYxrBni8siO5DXLLPCQawAzzZgDumKizPhh1Y=";
#   };
#   OPENSSL_NO_VENDOR = 1;
#   RUSTC_BOOTSTRAP = 1;
#   nativeBuildInputs = [
#     pkg-config
#     nodePackages.pnpm
#   ];
#   buildInputs =
#     [
#       # ncurses
#       openssl
#     ]
#     ++ lib.optionals stdenv.isDarwin [
#       darwin.Security
#       darwin.apple_sdk.frameworks.Carbon
#     ]
#     ++ lib.optionals stdenv.isLinux [
#       openssl
#       webkitgtk
#     ];
#   buildPhase = ''
#     pnpm install
#   '';
# }
{
  appimageTools,
  fetchzip,
  fetchurl,
  lib,
  stdenv,
}: let
  shortVersion = "0.11.2";
  build = "831";
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
      hash = "";
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
