{
  channels,
  disko,
  self,
  ...
}: final: prev: rec {
  # runitor = channels.unstable.runitor;
  # vscode = channels.unstable.vscode;
  # # android-tools = channels.unstable.android-tools;

  # glib = channels.unstable.glib;

  # glibc = channels.unstable.glibc;
  # webkitgtk = channels.unstable.webkitgtk;

  # OVMF = channels.unstable.OVMF;

  # netdata = channels.unstable.netdata;
  # nh = channels.unstable.nh;

  # _389-ds-base = self.packages."${prev.system}"._389;

  # freeipa = self.packages."${prev.system}".freeipa;
  # sssd = self.packages."${prev.system}".sssd;

  # ldb =
  #   #builtins.trace "ldb overlay prev: ${builtins.toString (builtins.attrNames prev)}"
  #   channels.unstable.ldb.override {
  #     python3 = channels.unstable.python311;
  #     cmocka = channels.unstable.cmocka;
  #   };
  # inshellisense = channels.unstable.inshellisense;
  # # sssd = channels.unstable.sssd.override {
  # #   ldb = ldb;
  # #   withSudo = true;
  # # };
  # sssd = self.packages."${prev.system}".sssd.override {
  #   ldb = ldb;
  #   withSudo = true;
  # };

  # # freeipa = channels.unstable.freeipa.override {
  # #   # ldb = ldbUnstable;
  # #   sssd = sssd;
  # #   _389-ds-base = _389-ds-base;
  # # };
  # freeipa = self.packages."${prev.system}".freeipa.override {
  #   # ldb = ldbUnstable;
  #   sssd = sssd;
  #   _389-ds-base = _389-ds-base;
  # };

  # samba = channels.unstable.samba;

  # disko = disko.packages."${prev.system}".disko;

  # tailscale = channels.unstable.tailscale;

  # cockpit = channels.unstable.cockpit;

  _389-ds-base = self.packages."${prev.system}"._389-ds-base;
  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  cockpit-ostree = self.packages."${prev.system}".cockpit-ostree;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;

  # keybase = channels.unstable.keybase;
  # keybase-gui = channels.unstable.keybase-gui;
  # kbfs = channels.unstable.kbfs;

  # atuin = channels.unstable.atuin;
  # xpipe = channels.unstable.xpipe;

  # trayscale = channels.unstable.trayscale;

  # catppuccin-gtk =
  #   channels
  #   .unstable
  #   .catppuccin-gtk;
  catppuccin-gtk = self.packages."${prev.system}"."catppuccin-gtk-7.4.0";

  systembus-notify = self.packages."${prev.system}".systembus-notify;

  authorized-keys = self.packages."${prev.system}".authorized-keys;

  # netscanner = channels.unstable.netscanner;

  # xdg-terminal-exec = channels.unstable.xdg-terminal-exec;

  # _1password-gui = channels.unstable._1password-gui;
  # _1password = channels.unstable._1password;

  # ntfs2btrfs = channels.unstable.ntfs2btrfs;

  # steam = channels.unstable.steam.override {
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       gamescope
  #       mangohud
  #     ];
  # };

  # sunshine = channels.unstable.sunshine;
}
