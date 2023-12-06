{ config, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    tmux
    vim
    wget
    curl
    git
    coreutils
    curl
    wget
    git
    git-lfs

    tailscale
    fortune
    cachix
    niv

    go
    gotools
    gopls
    go-outline
    gocode
    gopkgs
    gocode-gomod
    godef
    golint
    colima
    docker

    neofetch
    tmux
    yq
    bfg-repo-cleaner
    tmux
    nnn
    mtr
    dnsutils
    ldns
    htop
    vscode

    git

    btop

    firefox
  ];

}
