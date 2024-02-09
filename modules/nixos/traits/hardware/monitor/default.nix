{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.monitor;
in
  with lib;
  with lib.custom; {
    options.traits.hardware.monitor = {
      enable = mkBoolOpt false "monitor";
    };

    config = mkIf cfg.enable {
      system.nixos.tags = ["monitor"];

      boot = {
        kernelModules = ["i2c-dev"];
      };

      environment.systemPackages = with pkgs; [
        ddcutil
        # xorg.xbacklight
        gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
        # brightnessctl
      ];

      hardware.i2c.enable = true;
      # programs.light.enable = true;
    };
  }
