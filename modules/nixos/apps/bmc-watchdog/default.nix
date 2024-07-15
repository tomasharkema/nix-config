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

        script = ''
          exec ${pkgs.freeipmi}/bin/bmc-watchdog -d --timer-use=4 --pre-timeout-interrupt=2 --timeout-action=3 --initial-countdown=300 --log=0 --debug
        '';

        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          # PIDFile = "${pid}";

          Type = "simple";

          Restart = "always";
          RestartSec = 12;
        };
      };
    };
  };
}
