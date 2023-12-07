{ config, pkgs, ... }:
let youtube-dl = with pkgs.python3Packages; toPythonApplication youtube-dl;
in {

  environment.systemPackages = with pkgs; [
    # youtube-dl
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
    tmux
    nnn
    mtr
    dnsutils
    ldns
    htop
    vscode
    git
    btop
    screen
    pv
    xz
    _1password
    gh
    iftop
    zip
    unzip
    zsh-autosuggestions
    eza
    autojump
    thefuck
    powertop
    glances
    firefox
    tilix
    vscode
    gnome.gnome-session
    btrfs-progs
    gnome3.gedit
    gnome3.nautilus
    # python36
    # python36Packages.bpytop
    # xlibs.xmodmap
    # xlibs.xbacklight
    unrar
    unzip
    zsh
    snapper-gui
  ];
}
