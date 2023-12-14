{ pkgs, inputs, ... }:
let darwin-build = (import ../apps/darwin-build.nix);
in with pkgs;
[

  bash
  _1password
  cachix
  colmena
  antidote
  atuin

  autojump

  bat
  bfg-repo-cleaner
  bottom
  btop
  cheat
  colima
  coreutils
  curl
  delta
  dnsutils
  dog
  du-dust
  eza
  eza
  fd
  fortune
  fzf
  gh
  git
  git-lfs
  gtop
  home-manager
  iftop
  inputs.agenix.packages.${system}.default
  inputs.nix-cache-watcher.packages.${system}.nix-cache-watcher
  ipmitool
  ldns
  lolcat
  lsd
  mcfly
  morph
  mtr
  multitail
  ncdu
  neofetch
  netdiscover
  nil
  niv
  nix-deploy
  nix-index
  nix-prefetch-scripts
  nix-serve
  nixd
  nixfmt
  nixfmt
  nnn
  nodejs
  obsidian
  patchelf
  procs
  pv
  python3
  rnix-lsp
  screen
  silver-searcher
  speedtest-cli
  ssh-to-age
  starship
  tailscale
  thefuck
  thefuck
  tldr
  tree
  unrar
  unzip
  wget
  xz
  yq
  zip
  zsh
  zsh-autosuggestions

  (pkgs.writeShellScriptBin "upload-cache-signed" ''
    cd ~
    nix-cache-watcher sign-store -k ~/Developer/nix-config/cache-priv-key.pem -v && nix-cache-watcher upload-diff -r "https://nix-cache.harke.ma/" -v
  '')

] ++ (darwin-build { inherit pkgs; })
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
