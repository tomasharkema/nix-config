{ pkgs, inputs, ... }:
with pkgs; [

  inputs.agenix.packages.${system}.default
  manix

  nil
  nix
  nix-output-monitor
  nix-serve
  nix-tree
  nixd
  nixpkgs-fmt
  nurl
  nixci
]
