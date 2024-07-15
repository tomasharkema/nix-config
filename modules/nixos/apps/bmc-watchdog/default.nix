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

        environment = {
          PID = "${pid}";
          PIDFILE = "${pid}";
        };

        script = ''
          exec ${pkgs.freeipmi}/bin/bmc-watchdog -d -u 4 -p 0 -a 1 -i 300 --debug
        '';

        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        serviceConfig = {
          PIDFile = "${pid}";

          Type = "forking";

          Restart = "always";
          RestartSec = 12;
        };
      };
    };
  };
}
