{
  pkgs,
  inputs,
  ...
}:
with pkgs; let
  nix-fast-build = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-fast-build";
    rev = "4376b8a33b217ee2f78ba3dcff01a3e464d13a46";
    hash = "sha256-Emh0BPoqlS4ntp2UJrwydXfIP4qIMF0VBB2FUE3/M/E=";
  };
in [
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
