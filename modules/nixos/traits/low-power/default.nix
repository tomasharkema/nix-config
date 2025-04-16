{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.low-power;
in {
  options.traits.low-power = {
    enable = lib.mkEnableOption "low-power";
  };
  config = lib.mkIf cfg.enable {
    services = {
      netdata.enable = lib.mkForce false;
      tor.enable = lib.mkForce false;
      fwupd.enable = lib.mkForce false;
      promtail.enable = lib.mkForce false;
      usbguard.enable = lib.mkForce false;
    };

    apps = {
      attic.enable = false;
      resilio.enable = lib.mkForce false;
    };

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };
  };
}
