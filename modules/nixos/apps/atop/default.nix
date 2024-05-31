{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with lib.custom;
let
  cfg = config.apps.atop;
in
{

  options.apps.atop = {
    enable = mkEnableOption "atop";
    service = mkBoolOpt true "atop service";
    gpu = mkBoolOpt config.traits.hardware.nvidia.enable "atop gpu";
    httpd = mkEnableOption "atophttpd";
  };

  config = mkIf cfg.enable {

    programs.atop = {
      #   atopRotateTimer.enable = true;
      enable = true;
      setuidWrapper.enable = true;
      atopService.enable = cfg.service;
      #   atopacctService.enable = true;
      atopgpu.enable = cfg.gpu;
      netatop.enable = true;
    };

    systemd.services.atophttpd = mkIf cfg.httpd {
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
