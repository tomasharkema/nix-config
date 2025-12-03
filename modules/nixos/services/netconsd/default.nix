{
  pkgs,
  config,
  lib,
  ...
}: {
  options.services.netconsd = {
    enable = lib.mkEnableOption "enable netbox-service";
  };

  config = lib.mkIf config.services.netconsd.enable {
    systemd.services.netconsd = {
      description = "netconsd";
      script = "${pkgs.custom.netconsd}/bin/netconsd ${pkgs.custom.netconsd}/lib/printer.so";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        RestartSec = 5;
        Type = "simple";
      };
    };
  };
}
