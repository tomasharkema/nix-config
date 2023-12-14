{ pkgs,
#  agenix, nix-cache-watcher,
... }@attrs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  buildInputs = [ pkgs.home-manager ];
  packages = with pkgs; [
    bash
    bash-common-functions
    ack
    age
    # agenix.packages.${system}.default
    # nix-cache-watcher.packages.${system}.nix-cache-watcher
    # cachix
    # colmena
    deploy-rs
    git
    gnupg
    # go
    # go-outline
    # gocode
    # gocode-gomod
    # godef
    # golint
    # gopkgs
    # gopls
    # gotools
    netdiscover
    nix
    nix-tree
    nixpkgs-fmt
    python3
    sops
    ssh-to-age
    zsh
    nix-serve
  ];
  # shellHook = ''
  #   # cachix use tomasharkema
  # '';
}
