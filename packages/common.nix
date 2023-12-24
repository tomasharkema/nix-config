{
  pkgs,
  inputs,
  ...
} @ attrs: let
  darwin-build = (import ../apps/darwin-build.nix) attrs;
  nixpkgs-build = (import ./nixpkgs.nix) attrs;
in
  with pkgs;
    darwin-build
    ++ nixpkgs-build
    ++ [(lib.mkIf stdenv.isLinux atop)]
    ++ [(lib.mkIf stdenv.isLinux packagekit)]
    ++ [
      # vagrant
      _1password
      ## Nix tools
      antidote
      # atuin
      autojump
      bash
      bat
      bottom
      btop
      bunyan-rs
      cheat
      comma
      coreutils
      curl
      deadnix
      delta
      direnv
      dnsutils
      dogdns
      du-dust
      eza
      fd
      fortune
      fpp
      fx
      fzf
      gh
      git
      git-lfs
      gping
      gtop
      httpie
      iftop
      inputs.agenix.packages.${system}.default
      ipmitool
      just
      keybase
      ldns
      ldns
      lolcat
      lsd
      manix
      mcfly
      morph
      mosh
      mtr
      multitail
      navi
      ncdu
      ncdu
      neofetch
      netdiscover
      nil
      nix-index
      nix-prefetch-scripts
      nixd
      nnn
      nodejs
      # obsidian
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
      thefuck
      tldr
      tmate
      tree
      unrar
      unzip
      wget
      xz
      youtube-dl
      yq
      zip
      # zsh
      # zsh-autosuggestions
      # zsh-autocorrection
      # (pkgs.writeShellScriptBin "upload-cache-signed" ''
      #   cd ~
      #   nix-cache-watcher sign-store -k ~/Developer/nix-config/cache-priv-key.pem -v && nix-cache-watcher upload-diff -r "https://nix-cache.harke.ma/" -v
      # '')
    ]
# home.packages = with pkgs; [
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

