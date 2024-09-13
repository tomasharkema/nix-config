{
  channels,
  disko,
  self,
  inputs,
  ...
}: final: prev: rec {
  libcec = prev.libcec.override {withLibraspberrypi = true;};

  nix-htop = inputs.nix-htop.packages."${prev.system}".nix-htop;

  _389-ds-base = self.packages."${prev.system}"._389-ds-base;
  freeipa = self.packages."${prev.system}".freeipa;
  sssd = self.packages."${prev.system}".sssd.override {withSudo = true;};

  docset = inputs.nixos-dash-docset.packages."${prev.system}".docset;

  tailscalesd = inputs.tailscalesd.packages."${prev.system}".tailscalesd;
  tsui = inputs.tsui.packages."${prev.system}".tsui;

  piratebay = inputs.piratebay.packages."${prev.system}".default;

  # dosbox-x = prev.dosbox-x.overrideAttrs ({postInstall ? "", ...}: {
  #   postInstall =
  #     postInstall
  #     + prev.lib.optionalString prev.hostPlatform.isDarwin ''
  #       cp -v ${prev.custom.openglide}/lib/* $out/Applications/dosbox-x.app/Contents/Resources/
  #     '';
  #   # https://www.vogons.org/download/file.php?id=102360
  # });
  # ffmpeg = prev.ffmpeg.override {ffmpegVariant = "full";};

  cockpit-podman = self.packages."${prev.system}".cockpit-podman;
  cockpit-tailscale = self.packages."${prev.system}".cockpit-tailscale;
  cockpit-ostree = self.packages."${prev.system}".cockpit-ostree;
  cockpit-machines = self.packages."${prev.system}".cockpit-machines;
  authorized-keys = self.packages."${prev.system}".authorized-keys;

  ssh-tpm-agent = self.packages."${prev.system}".ssh-tpm-agent;

  intel-vaapi-driver = prev.intel-vaapi-driver.override {enableHybridCodec = true;};

  # steam = prev.steam.override {
  #   extraEnv = {
  #     # MANGOHUD = true;
  #     # OBS_VKCAPTURE = true;
  #     # RADV_TEX_ANISO = 16;
  #   };
  #   extraPkgs = pkgs:
  #     with pkgs; [
  #       # mangohud
  #       gamemode
  #     ];
  #   extraLibraries = p:
  #     with p; [
  #       atk
  #       # mangohud
  #     ];
  # };
}
