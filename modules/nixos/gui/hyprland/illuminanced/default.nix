{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.hyrland.wluma;
in {
  options.gui.hyrland.wluma = {
    enable = lib.mkEnableOption "illuminanced";

    backlightDevice = lib.mkOption {
      type = lib.types.str;
      default = "/sys/bus/ddcci/devices/*/backlight/*";
    };
    sensorDevice = lib.mkOption {
      type = lib.types.str;
      default = "/sys/bus/iio/devices/*";
    };
    udev = lib.mkEnableOption "udev";
  };
  config = lib.mkIf cfg.enable {
    # SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", ATTRS{serial}=="A6008isP", SYMLINK+="arduino"
    services.udev.extraRules = let
      run_gpio = pkgs.writeShellScript "run_gpio.sh" ''
        echo bh1750 0x23 > "/sys$DEVPATH/device/new_device"
      '';
    in ''
      ACTION=="add", SUBSYSTEM=="i2c-dev", ATTRS{product_id}=="0xea90", ATTRS{vendor_id}=="0x10c4", RUN+="${run_gpio}"
    '';

    systemd = lib.mkIf false {
      user.services = {
        wluma = {
          description = "Ambient light monitoring Service";

          wantedBy = ["graphical-session.target"];

          # restartTriggers = [configFile];
          script = "${pkgs.wluma}/bin/wluma";
        };
      };
    };
  };
}
