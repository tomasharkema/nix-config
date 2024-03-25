{
  channels,
  self,
  ...
}: final: prev: {
  runitor = channels.unstable.runitor;
  hydra_unstable = channels.unstable.hydra_unstable;
  vscode = channels.unstable.vscode;
  android-tools = channels.unstable.android-tools;

  OVMF = channels.unstable.OVMF;

  netdata = channels.unstable.netdata;

  freeipa = self.packages."${prev.system}".freeipa;
  sssd = self.packages."${prev.system}".sssd;
  # freeipa = channels.unstable.freeipa;
  # sssd = channels.unstable.sssd;

  cockpit = channels.unstable.cockpit;
  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  # cockpit-ostree = self.packages."${prev.system}".cockpit-ostree;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;

  keybase = channels.unstable.keybase;
  keybase-gui = channels.unstable.keybase-gui;
  kbfs = channels.unstable.kbfs;

  atuin = channels.unstable.atuin;
  xpipe = channels.unstable.xpipe;

  # catppuccin-gtk = channels.unstable.catppuccin-gtk;

  systembus-notify = self.packages."${prev.system}".systembus-notify;

  netscanner = channels.unstable.netscanner;

  xdg-terminal-exec = channels.unstable.xdg-terminal-exec;

  _1password-gui = channels.unstable._1password-gui;
  _1password = channels.unstable._1password;
}
