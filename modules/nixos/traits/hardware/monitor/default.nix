{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.monitor;
in {
  options.traits.hardware.monitor = {enable = lib.mkEnableOption "monitor";};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["monitor"];

    boot = {
      kernelModules = [
        "i2c-dev"
        # "ddcci_backlight"
      ];
      # extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    };

    environment.systemPackages = with pkgs; [
      # ddcutil
      # xorg.xbacklight
      # gnomeExtensions.control-monitor-brightness-and-volume-with-ddcutil
      brightnessctl
    ];

    services.ddccontrol.enable = true;
    hardware.i2c.enable = true;
    # programs.light.enable = true;
  };
}
