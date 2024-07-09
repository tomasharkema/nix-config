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
    options.traits.hardware.monitor = {enable = mkBoolOpt false "monitor";};

    config = mkIf cfg.enable {
      system.nixos.tags = ["monitor"];

      boot = {
        kernelModules = ["i2c-dev" "ddcci_backlight"];
        extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
      };

      users.groups = {"i2c" = {};};

      users.users.${config.user.name} = {extraGroups = ["i2c"];};

      environment.systemPackages = with pkgs; [
        ddcutil
        # xorg.xbacklight
        # gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
        brightnessctl
      ];

      services.ddccontrol.enable = true;
      hardware.i2c.enable = true;
      # programs.light.enable = true;
    };
  }
