{
  channels,
  self,
  ...
}: final: prev: {
  runitor = channels.unstable.runitor;
  vscode = channels.unstable.vscode;
  # android-tools = channels.unstable.android-tools;

  OVMF = channels.unstable.OVMF;

  netdata = channels.unstable.netdata;
  nh = channels.unstable.nh;
  freeipa = self.packages."${prev.system}".freeipa;
  sssd = self.packages."${prev.system}".sssd;
  # freeipa = channels.unstable.freeipa;
  # sssd = channels.unstable.sssd;

  # tailscale = channels.unstable.tailscale;

  cockpit = channels.unstable.cockpit;
  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  cockpit-ostree = self.packages."${prev.system}".cockpit-ostree;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;

  keybase = channels.unstable.keybase;
  keybase-gui = channels.unstable.keybase-gui;
  kbfs = channels.unstable.kbfs;

  atuin = channels.unstable.atuin;
  xpipe = channels.unstable.xpipe;

  catppuccin-gtk = channels.unstable.catppuccin-gtk;

  systembus-notify = self.packages."${prev.system}".systembus-notify;

  authorized-keys = self.packages."${prev.system}".authorized-keys;

  netscanner = channels.unstable.netscanner;

  xdg-terminal-exec = channels.unstable.xdg-terminal-exec;

  _1password-gui = channels.unstable._1password-gui;
  _1password = channels.unstable._1password;

  ntfs2btrfs = channels.unstable.ntfs2btrfs;

  # steam = channels.unstable.steam.override {
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       gamescope
  #       mangohud
  #     ];
  # };
}
