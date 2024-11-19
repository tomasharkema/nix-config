{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.prometheus;
  journalPort = config.prometheus.journald-exporter.port;
in {
  options.prometheus.journald-exporter = {
    port = lib.mkOption {
      default = 12345;
    };
  };

  config = lib.mkIf (cfg.enable && false) {
    users = {
      users = {
        journald-exporter = {
          isSystemUser = true;
          group = "journald-exporter";
        };
      };
      groups.journald-exporter = {};
    };

    #   netdata.configDir."go.d/prometheus.conf" = format.generate "prometheus.conf" {
    # jobs =
    #   [
    #     {
    #       name = "journald-exporter";
    #       url = "http://127.0.0.1:${builtins.toString config.prometheus.journald-exporter.port}/metrics";
    #     }
    #   ];
    #   };

    systemd = {
      tmpfiles.settings."80-journald-exporter" = {
        "/etc/journald-exporter/keys".d = {
          user = "root";
          group = "root";
          mode = "0755";
        };
      };

      services = {
        "journald-exporter" = {
          description = "journald-exporter";

          after = ["network.target"];

          # AssertPathIsDirectory=/etc/journald-exporter/keys

          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "notify";
            ExecStart = "${pkgs.custom.journald-exporter}/bin/journald-exporter --key-dir /etc/journald-exporter/keys --port ${builtins.toString journalPort}";
            WatchdogSec = "5m";
            Restart = "always";
            NoNewPrivileges = "true";
            ProtectSystem = "strict";
            ProtectClock = "true";
            ProtectKernelTunables = "true";
            ProtectKernelModules = "true";
            ProtectKernelLogs = "true";
            ProtectControlGroups = "true";
            MemoryDenyWriteExecute = "true";
            SyslogLevel = "warning";
            SyslogLevelPrefix = "false";
          };
        };
      };
    };
  };
}
