{ pkgs
, inputs
, ...
} @ attrs:
pkgs.mkShell {
  # defaultPackage = pkgs.nix-tree;
  # buildInputs = [pkgs.home-manager];
  packages = with pkgs; [
    bash
    ack
    age
    inputs.agenix.packages.${system}.default
    inputs.nix-cache-watcher.packages.${system}.nix-cache-watcher
    inputs.attic.packages.${system}.default
    # cachix
    colmena
    deploy-rs
    git
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
    netdiscover
    nix
    nix-tree
    nixpkgs-fmt
    nix-du
    nil
    nixd
    python3
    sops
    ssh-to-age
    zsh
    nix-serve
    nix-output-monitor
  ];
  # shellHook = ''
  #   # cachix use tomasharkema
  # '';
}
