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

  # modemmanager = prev.modemmanager.overrideAttrs (oldAttrs: {
  # src = prev.fetchFromGitLab {
  #   # https://gitlab.freedesktop.org/tuxor1337/ModemManager/-/tree/port-xmm7360
  #   domain = "gitlab.freedesktop.org";
  #   owner = "tuxor1337";
  #   repo = "ModemManager";
  #   rev = "port-xmm7360";
  #   sha256 = "sha256-eUamC9Bi9HpukWXVLol6O3QoNFa5mIMNOake2IDSEFU=";
  # };
  # patches =
  #   oldAttrs.patches
  #   ++ [
  #     (prev.fetchpatch {
  #       url = "https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/1200.patch";
  #       hash = "sha256-7z3YMNbrU1E55FgmOaTFbsK2qXCBnbRkDrS+Yogxgow=";
  #     })
  #   ];
  # });

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
