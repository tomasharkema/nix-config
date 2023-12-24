{
  pkgs,
  inputs,
  ...
}:
with pkgs;
with inputs; [
  agenix.packages.${system}.default
  manix
  nix-init
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
