{ pkgs, ... }:
with pkgs; [
  _1password
  antidote
  autojump
  bfg-repo-cleaner
  btop
  cachix
  cheat
  colima
  colmena
  coreutils
  curl
  curl
  dnsutils
  dog
  eza
  fortune
  gh
  git
  git-lfs
  gtop
  home-manager
  iftop
  ldns
  mcfly
  morph
  mtr
  neofetch
  niv
  nix-deploy
  nixfmt
  nnn
  nodejs
  procs
  pv
  python3
  screen
  ssh-to-age
  starship
  thefuck
  tldr
  tmux
  unrar
  unzip
  unzip
  vim
  wget
  xz
  yq
  zip
  zsh
  zsh-autosuggestions
  nixd
  tailscale
]
# home.packages = with pkgs; [

#   ldns
#   eza
#   bottom
#   multitail
#   netdiscover
#   obsidian
#   tree
#   inputs.agenix.packages.${system}.default
#   atuin
#   thefuck
#   nixd
#   nil
#   rnix-lsp
#   ## Nix tools
#   nix-index
#   nix-prefetch-scripts
#   patchelf
#   bat
#   lsd
#   delta
#   du-dust
#   ncdu
#   fd
#   silver-searcher
#   fzf
#   # moonlight
#   # (vscode-with-extensions.override {
#   #   vscodeExtensions = with vscode-extensions;
#   #     [
#   #       bbenoist.nix
#   #       ms-python.python
#   #       ms-azuretools.vscode-docker
#   #       ms-vscode-remote.remote-ssh
#   #     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
#   #       name = "remote-ssh-edit";
#   #       publisher = "ms-vscode-remote";
#   #       version = "0.47.2";
#   #       sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
#   #     }];
#   # })
# ];
