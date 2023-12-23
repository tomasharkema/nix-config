{
  pkgs,
  inputs,
  statix,
  alejandra,
  nix-cache-watcher,
  nixpkgs-lint,
  agenix,
  ...
}:
with pkgs; [
  agenix.packages.${system}.default
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

  statix.packages.${system}.statix
  alejandra.defaultPackage.${system}
  nix-cache-watcher.packages.${system}.nix-cache-watcher
  nixpkgs-lint.packages.${system}.default
]
