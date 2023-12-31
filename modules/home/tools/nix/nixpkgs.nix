{
  pkgs,
  inputs,
  ...
}:
with pkgs; [
  inputs.fh.packages.${system}.default

  agenix # .packages.${system}.default
  alejandra # .defaultPackage.${system}
  deadnix
  manix
  nil #.packages.${system}.default
  nix
  hydra-cli
  # inputs.bento.packages.${system}.default
  #  nix-cache-watcher
  nix-fast-build
  nix-eval-jobs
  nix-init
  nix-output-monitor
  nix-prefetch-scripts
  nix-serve
  nix-tree
  nixci
  nixd
  nixos-shell
  nixpkgs-fmt
  nixpkgs-lint
  nurl
  statix
]
