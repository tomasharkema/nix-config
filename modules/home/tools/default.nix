{
  inputs,
  pkgs,
  ...
}:
with pkgs; {
  config = {
    home.packages = with pkgs; [
      ssh-tools
      tg
      wiki-tui
      tran
      lazycli
      trash-cli
      gtrash
      rmtrash
      grex
      dasht
      ipcalc
      sshs
      # bup
      # shallow-backup
      # dry
      # pkgs.deepin.udisks2-qt5
      # udisks2
      portal
      git
      wget
      curl
      sysz
      # netscanner
      bandwhich
      bashmount
      bmon
      # compsize
      ctop
      curl
      # devtodo
      devdash
      wtf
      # fwupd
      # fwupd-efi
      # hw-probe
      # kmon
      lazydocker
      # lm_sensors
      # ncdu
      # nfs-utils

      openldap
      # pciutils
      pv
      sshportal
      systemctl-tui
      # tiptop
      # tpm-tools
      # udiskie
      tremc
      # usermount
      viddy
      wget
      nix-top
      # nixos-anywhere
      lnav
      # mattermost-desktop
      # tg
      # _1password
      # thefuck
      antidote
      # autojump
      bash
      bat
      bottom

      bunyan-rs
      cheat
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

      git
      git-lfs
      gping

      httpie
      iftop
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
      # guardian-agent
      mtr
      multitail
      navi
      # ncdu
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
      tlrc
      tmate
      tree
      unrar
      unzip
      wget
      xz
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
