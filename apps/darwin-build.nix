{
  pkgs,
  lib,
  ...
}: let
  darwin-build =
    #lib.mkIf pkgs.stdenv.isDarwin
    pkgs.writeShellScriptBin "darwin-build" ''
      darwin-rebuild switch --flake ~/Developer/nix-config
    '';
  nixos-build =
    #lib.mkIf pkgs.stdenv.isLinux
    pkgs.writeShellScriptBin "nixos-build" ''
      sudo nixos-rebuild switch --flake ~/nix-config --log-format internal-json -v |& nom --json
    '';
in [darwin-build nixos-build]
