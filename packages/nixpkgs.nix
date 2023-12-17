{ pkgs, agenix, attic, nix-cache-watcher, ... }: with pkgs; [

  agenix.packages.${system}.default
  attic.packages.${system}.default
  nix-cache-watcher.packages.${system}.nix-cache-watcher
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
