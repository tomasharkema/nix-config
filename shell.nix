{ pkgs, inputs, ... }@attrs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  # buildInputs = [ pkgs.home-manager ];
  packages = with pkgs; [
    ack
    age
    inputs.agenix.packages.${system}.default
    inputs.nix-cache-watcher.packages.aarch64-darwin.nix-cache-watcher
    # cachix
    # colmena
    deploy-rs
    git
    gnupg
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
    home-manager
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
