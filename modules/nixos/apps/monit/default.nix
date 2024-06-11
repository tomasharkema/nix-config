{ config, pkgs, lib, ... }:
with lib; {
  options.apps.monit = {
    port = mkOption {
      type = types.str;
      default = "2812";
    };
  };

  config = mkIf false {
    services.monit = {
      enable = true;
      config = mkBefore ''
        set daemon  30
        set logfile syslog

        set httpd port ${config.apps.monit.port} and
          use address 0.0.0.0
          allow localhost
          allow admin:monit

        check system $HOST
          if loadavg (5min) > 3 then alert
          if loadavg (15min) > 1 then alert
          if memory usage > 80% for 4 cycles then alert
          if swap usage > 20% for 4 cycles then alert
          # Test the user part of CPU usage
          if cpu usage (user) > 80% for 2 cycles then alert
          # Test the system part of CPU usage
          if cpu usage (system) > 20% for 2 cycles then alert
          # Test the i/o wait part of CPU usage
          if cpu usage (wait) > 80% for 2 cycles then alert
          # Test CPU usage including user, system and wait. Note that
          # multi-core systems can generate 100% per core
          # so total CPU usage can be more than 100%
          if cpu usage > 200% for 4 cycles then alert
      '';
    };

    proxy-services.services = {
      "/monit/" = {
        proxyPass = "http://localhost:${config.apps.monit.port}/";
      };
    };
  };
}
