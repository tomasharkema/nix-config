{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  options.apps.monit = {
    port = mkOption {
      type = types.str;
      default = "2812";
    };
  };

  config = {
    services.monit = {
      enable = true;
      config = ''
        set daemon  30
        set logfile syslog

        set httpd port ${config.apps.monit.port} and
          use address localhost
          allow localhost
          allow admin:monit
      '';
    };

    proxy-services.services = {
      "/monit/" = {
        proxyPass = "http://localhost:${config.apps.monit.port}/";
      };
    };
  };
}
