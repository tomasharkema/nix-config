{
  pkgs,
  inputs,
  ...
}:
with pkgs;
with inputs; {
  config.home.packages = [
    agenix # .packages.${system}.default
    alejandra # .defaultPackage.${system}
    deadnix
    manix
    nil #.packages.${system}.default
    nix
    nix-cache-watcher.packages.${system}.nix-cache-watcher
    nix-init
    nix-output-monitor
    nix-prefetch-scripts
    nix-serve
    nix-tree
    nixci
    nixd
    nixos-shell
    nixpkgs-fmt
    nixpkgs-lint.packages.${system}.default
    nurl
    statix.packages.${system}.statix
  ];
}
