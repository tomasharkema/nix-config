{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.ntopng;
in {
  options.apps.ntopng = {enable = lib.mkEnableOption "ntopng";};
  config = lib.mkIf (cfg.enable && false) {
    services = {
      ntopng = {
        enable = true;
        httpPort = 3457;
        extraConfig = ''
          --http-prefix="/ntopng"
        '';
      };
    };
    proxy-services.services = {
      "/ntopng" = {
        proxyPass = "http://localhost:${toString config.services.ntopng.httpPort}/";
        extraConfig = ''
          rewrite /ntopng(.*) $1 break;
        '';
      };
    };
  };
}
