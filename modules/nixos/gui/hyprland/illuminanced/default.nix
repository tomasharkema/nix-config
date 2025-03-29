{
  config,
  pkgs,
  lib,
  ...
}: let
  # /sys/bus/ddcci/devices/*/backlight/*/
  backlightDevice = "/sys/bus/ddcci/devices/*/backlight/*";
  sensorDevice = "/sys/bus/iio/devices/*";
  pid = "/run/illuminanced.pid";
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
    max_backlight_file = "${backlightDevice}/max_brightness"
    backlight_file = "${backlightDevice}/brightness"
    illuminance_file = "${sensorDevice}/in_illuminance_raw"
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
  cfg = config.gui.hyrland.illuminanced;
in {
  options.gui.hyrland.illuminanced = {enable = lib.mkEnableOption "illuminanced";};

  config = lib.mkIf cfg.enable {
    systemd.services = {
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
