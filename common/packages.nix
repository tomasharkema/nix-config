{ pkgs, ... }: {
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
    fortune
    cachix
    niv
    starship
    obsidian
    python3
    # go
    # gotools
    # gopls
    # go-outline
    # gocode
    # gopkgs
    # gocode-gomod
    # godef
    # golint
    # colima
    # docker
    neofetch
    tmux
    yq
    tmux
    nnn
    mtr
    dnsutils
    ldns
    # htop
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
    unrar
    unzip
    zsh
    nodejs
    packagekit
    gnomeExtensions.gsconnect
    # cockpit-pcp
  ];
}
