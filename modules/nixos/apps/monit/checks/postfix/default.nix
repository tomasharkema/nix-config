{ config, pkgs, lib, ... }:
with lib; {
  config =
    mkIf (config.services.monit.enable && config.services.postfix.enable) {
      services.monit = {
        config = ''
          check process postfix with pidfile /var/lib/postfix/queue/pid/master.pid
            group mail
            start program = "${pkgs.postfix}/bin/postfix start"
            stop  program = "${pkgs.postfix}/bin/postfix stop"
            if failed port 25 protocol smtp then restart
            depends on postfix_rc

          check file postfix_rc with path ${pkgs.postfix}/bin/postfix
            group mail
            if failed checksum then unmonitor
            if failed permission 755 then unmonitor
            if failed uid root then unmonitor
            if failed gid root then unmonitor
        '';
      };
    };
}
