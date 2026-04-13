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
      tor.enable = lib.mkForce false;
      fwupd.enable = lib.mkForce false;
    };

    apps = {
      resilio.enable = lib.mkForce false;

      netdata.enable = lib.mkForce false;
      usbguard.enable = lib.mkForce false;
    };

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };
  };
}
