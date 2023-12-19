{ pkgs
, inputs
, ...
}@attrs:
let
  darwin-build = import ../apps/darwin-build.nix;
  nixpkgs-build = import ./nixpkgs.nix;
in
with pkgs;
[
  _1password
  antidote
  atuin
  autojump
  bash
  bat
  bottom
  btop
  cheat
  comma
  coreutils
  curl
  deadnix
  delta
  deploy-rs
  dnsutils
  dog
  du-dust
  eza
  eza
  fd
  fortune
  fpp
  fzf
  gh
  git
  git-lfs
  gping
  gtop
  iftop
  ipmitool
  ldns
  lolcat
  lsd
  manix
  mcfly
  morph
  mtr
  multitail
  navi
  ncdu
  neofetch
  netdiscover
  nnn
  nodejs
  patchelf
  procs
  pv
  python3
  screen
  silver-searcher
  speedtest-cli
  ssh-to-age
  starship
  tailscale
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
  # (pkgs.writeShellScriptBin "upload-cache-signed" ''
  #   cd ~
  #   nix-cache-watcher sign-store -k ~/Developer/nix-config/cache-priv-key.pem -v && nix-cache-watcher upload-diff -r "https://nix-cache.harke.ma/" -v
  # '')
]
++ (darwin-build attrs) ++ (nixpkgs-build attrs) ++ [ (lib.mkIf stdenv.isLinux packagekit) ]
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

