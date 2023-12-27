{
  pkgs,
  lib,
  ...
}:
with pkgs; let
  nixos-build = writeShellScriptBin "nixos-build" ''
    sudo nixos-rebuild switch --flake ~/nix-config --log-format internal-json -v |& nom --json
  '';
in {
  config = {
    environment.systemPackages = [
      nixos-build
    ];
  };
}
