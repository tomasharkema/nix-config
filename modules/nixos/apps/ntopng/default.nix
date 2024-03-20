{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  options.apps.ntopng = {
    enable = mkEnableOption "ntopng";
  };
  config = {
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
