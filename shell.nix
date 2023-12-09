{ pkgs, colmena, deploy-rs, ... }@inputs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  # buildInputs = [ home-manager ];
  packages = with pkgs; [
    home-manager
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
    python3
    go
    gotools
    gopls
    go-outline
    gocode
    gopkgs
    gocode-gomod
    godef
    golint
    netdiscover
    # anywhere
  ];
  shellHook = ''
    cachix use tomasharkema
  '';
}
