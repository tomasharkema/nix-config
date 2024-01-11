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

  config = {
    environment.systemPackages = with pkgs; [sbctl];
    boot = {
      lanzaboote = mkIf cfg.enable {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        systemd-boot = lib.mkIf cfg.enable {
          enable = false;
        };
      };
    };
  };
}
