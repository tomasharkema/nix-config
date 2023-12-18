{ pkgs, inputs, ... }:
with pkgs; [

  inputs.agenix.packages.${system}.default
  inputs.attic.packages.${system}.default
  inputs.nix-cache-watcher.packages.${system}.nix-cache-watcher
  manix

  nil
  nix
  nix-output-monitor
  nix-serve
  nix-tree
  nixd
  nixpkgs-fmt
  nurl
]
