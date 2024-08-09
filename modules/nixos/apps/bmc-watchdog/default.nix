{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps."bmc-watchdog";
  pid = "/run/bmc-watchdog.pid";
in {
  options.apps."bmc-watchdog" = {enable = mkEnableOption "bmc watchdog";};

  config = mkIf cfg.enable {
    systemd.services = {
      "bmc-watchdog" = {
        enable = true;
        description = "BMC Watchdog Timer Daemon";

        # environment = {
        #   PID = "${pid}";
        #   PIDFILE = "${pid}";
        # };
        # ${pkgs.ipmitool}/bin/ipmitool raw 0x06 0x24 0x04 0x01 0x00 0x00 0x55 0x00
        preStart = ''
          ${pkgs.freeipmi}/bin/bmc-watchdog --clear
        '';

        script = ''
          exec ${pkgs.freeipmi}/bin/bmc-watchdog \
            -d \
            --timer-use=4 \
            --pre-timeout-interrupt=2 \
            --timeout-action=3 \
            --initial-countdown=300 \
            --log=0 \
            --logfile=/var/log/freeipmi/bmc-watchdog.log \
            --debug
        '';

        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          # PIDFile = "${pid}";

          Type = "simple";
          # Type = "forking";

          Restart = "always";
          RestartSec = 12;
        };
      };
    };
  };
}
