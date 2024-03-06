{
  config,
  pkgs,
  ...
}: {
  config = {
    services.monit = {
      enable = true;
      config = ''
        set daemon  30
        set logfile syslog

        set httpd port 2812 and
          use address localhost
          allow localhost
          allow admin:monit
      '';
    };
  };
}
