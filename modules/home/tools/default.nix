{
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  config = {
    home.packages = with pkgs; [
      # mattermost-desktop
      tg
      _1password
      thefuck
      antidote
      autojump
      bash
      bat
      bottom
      btop
      bunyan-rs
      cheat
      comma
      coreutils
      ctop
      curl
      curlie
      delta
      direnv
      dnsutils
      dogdns
      du-dust
      eza
      fd
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
      inputs.devenv.packages.${system}.default
      ipmitool
      just
      # keybase
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
      zsh
    ];
  };
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
}
