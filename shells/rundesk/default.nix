{
  pkgs,
  stdenv,
  lib,
  ...
}:
# let
# unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz") {};
# toolchains = [unstable.jdk11 unstable.jdk17];
# run-imager = pkgs.writeShellApplication {
#   name = "imager";
#   runtimeInputs = with pkgs; [rd gum];
#   text = ''
#     export RD_AUTH_PROMPT=false
#     export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
#     export RD_URL=https://rundeck.harkema.io
#     gum confirm "Build $1?"
#     rd run -i 513a69b3-116b-4d7e-b396-11adcc0117e5 -f -- -image "$1"
#   '';
# };
# pkgs.writeShellScriptBin "run-imager" ''
#   export RD_AUTH_PROMPT=false
#   export RD_TOKEN="9LczxcesPidTMTpPAK1LSoWdVYi9wixx"
#   export RD_URL=https://rundeck.harkema.io
#   echo "Run imager: $1"
#   ${pkgs.lib.getExe rd} run -i 513a69b3-116b-4d7e-b396-11adcc0117e5 -f -- -image $1
# '';
# packages = with pkgs; [
#   rd
#   run-imager
# ];
# in
pkgs.mkShell {
  name = "rundesk";
  buildInputs = with pkgs.custom; [
    rd-runner
    rd-imager
  ];

  defaultInput = pkgs.rd-runner;
}
