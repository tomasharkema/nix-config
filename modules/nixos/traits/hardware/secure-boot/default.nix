{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.secure-boot;
in {
  options.traits = {
    hardware.secure-boot = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [sbctl];
    boot = {
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot.enable = lib.mkForce false;
      };
    };
  };
}
