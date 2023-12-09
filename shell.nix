{ pkgs, colmena, deploy-rs, ... }@inputs:
pkgs.mkShell {
  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
  # defaultPackage = pkgs.nix-tree;
  # buildInputs = [ home-manager ];
  packages = with pkgs; [
    # home-manager
    nix-tree
    nixpkgs-fmt
    git
    zsh
    sops
    ssh-to-age
    gnupg
    age
    cachix
    nix
    deploy-rs
    colmena
    # anywhere
  ];
}
