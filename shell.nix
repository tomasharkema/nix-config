{ pkgs, colmena, deploy-rs, agenix, ... }@inputs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  # buildInputs = [ pkgs.home-manager ];
  packages = with pkgs; [
    ack
    age
    agenix.packages.${system}.default
    cachix
    colmena
    deploy-rs
    git
    gnupg
    gnupg
    go
    go-outline
    gocode
    gocode-gomod
    godef
    golint
    gopkgs
    gopls
    gotools
    home-manager
    netdiscover
    nix
    nix-tree
    nixpkgs-fmt
    python3
    sops
    ssh-to-age
    ssh-to-age
    zsh
    # conda
  ];
  shellHook = ''
    cachix use tomasharkema
  '';
}
