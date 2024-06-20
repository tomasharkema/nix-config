{
  channels,
  disko,
  self,
  ...
}: final: prev: rec {
  libcec = prev.libcec.override {withLibraspberrypi = true;};

  _389-ds-base = self.packages."${prev.system}"._389-ds-base;
  freeipa = self.packages."${prev.system}".freeipa;
  sssd = self.packages."${prev.system}".sssd.override {withSudo = true;};

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

  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  cockpit-ostree = self.packages."${prev.system}".cockpit-ostree;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;
  authorized-keys = self.packages."${prev.system}".authorized-keys;

  steam = prev.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        gamescope
        mangohud
      ];
  };
}
