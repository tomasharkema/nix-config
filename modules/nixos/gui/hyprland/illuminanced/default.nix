{
  config,
  pkgs,
  lib,
  ...
}: let
  pid = "/run/illuminanced.pid";
  cfg = config.gui.hyrland.illuminanced;
in {
  options.gui.hyrland.illuminanced = {
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
        {
          echo bh1750 0x23 > "/sys$DEVPATH/device/new_device"
          systemctl restart illuminanced.service
        } &>> "/var/log/run_gpio.log"
      '';
    in ''
      ACTION=="add", SUBSYSTEM=="i2c-dev", ATTRS{product_id}=="0xea90", ATTRS{vendor_id}=="0x10c4", RUN+="${run_gpio}"
    '';

    systemd.services = let
      configFile = pkgs.writeText "config.toml" ''
        [daemonize]
        log_to = "syslog"
        pid_file = "${pid}"
        # log_level = "OFF", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"
        log_level = "INFO"

        [general]
        check_period_in_seconds = 1
        light_steps = 10
        min_backlight = 70
        step_barrier = 0.1
        max_backlight_file = "${cfg.backlightDevice}/max_brightness"
        backlight_file = "${cfg.backlightDevice}/brightness"
        illuminance_file = "${cfg.sensorDevice}/in_illuminance_raw"
        event_device_mask = "/dev/input/event*"
        event_device_name = "Asus WMI hotkeys"
        enable_max_brightness_mode = true
        filename_for_sensor_activation = ""

        [kalman]
        q = 1
        r = 20
        covariance = 10

        [light]
        points_count = 6

        illuminance_0 = 0
        light_0 = 0

        illuminance_1 = 20
        light_1 = 1

        illuminance_2 = 300
        light_2 = 3

        illuminance_3 = 700
        light_3 = 4

        illuminance_4 = 1100
        light_4 = 5

        illuminance_5 = 7100
        light_5 = 10
      '';
    in {
      illuminanced = {
        description = "Ambient light monitoring Service";

        # wants = [
        #   "syslog.socket"
        # ];

        wantedBy = ["multi-user.target"];

        unitConfig = {
          Documentation = "https://github.com/mikhail-m1/illuminanced";
        };

        restartTriggers = [configFile];

        serviceConfig = {
          Type = "forking";
          ExecStart = "${pkgs.custom.illuminanced}/bin/illuminanced -c ${configFile}";
          PIDFile = pid;
          Restart = "on-failure";
        };
      };
    };
  };
}
