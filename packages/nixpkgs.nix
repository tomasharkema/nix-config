{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  inputs.agenix.packages.${system}.default
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

  inputs.statix.packages.${system}.statix
  inputs.alejandra.defaultPackage.${system}
  inputs.nix-cache-watcher.packages.${system}.nix-cache-watcher
  inputs.nixpkgs-lint.packages.${system}.default
]
