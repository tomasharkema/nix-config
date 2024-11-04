{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.apps.atop;
in {
  options.apps.atop = {
    enable = lib.mkEnableOption "atop";
    httpd = lib.mkEnableOption "atophttpd";
  };

  config = lib.mkIf cfg.enable {
    programs.atop = {
      atopRotateTimer.enable = true;
      enable = true;
      setuidWrapper.enable = true;
      atopService.enable = true;
      atopacctService.enable = true;
      atopgpu.enable = true;
      netatop.enable = true;
    };
    environment.systemPackages = [pkgs.atop];
    # systemd.services.atophttpd = mkIf cfg.httpd {
    #   enable = true;
    #   description = "atophttpd";
    #   script = "${pkgs.custom.atophttpd}/bin/atophttpd -a 0.0.0.0";
    #   unitConfig = {
    #     Type = "simple";
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   serviceConfig = {
    #     Restart = "on-failure";
    #     RestartSec = 5;
    #   };
    #   wantedBy = ["multi-user.target"];
    # };
  };
}
