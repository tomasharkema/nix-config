{ config, pkgs, lib, ... }:
with lib; {
  options.apps.atophttpd = { enable = mkEnableOption "atophttpd"; };

  config = mkIf config.apps.atophttpd.enable {
    systemd.services.atophttpd = {
      enable = true;
      description = "atophttpd";
      script = "${pkgs.custom.atophttpd}/bin/atophttpd -a 0.0.0.0";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
