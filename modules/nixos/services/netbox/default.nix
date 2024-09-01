{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.services.netbox-service;
in {
  options.services.netbox-service = {
    enable = mkBoolOpt false "enable netbox-service";
  };

  config = mkIf cfg.enable {
    systemd.services.netbox = { serviceConfig = { TimeoutSec = 900; }; };

    services.netbox = {
      enable = true;
      secretKeyFile = "/var/lib/netbox/secret-key-file";
      listenAddress = "127.0.0.1";
      settings = { BASE_PATH = "netbox/"; };
    };

    proxy-services.services = {
      "/netbox/static/" = {
        alias = "${config.services.netbox.dataDir}/static/";
      };
      "/netbox/" = {
        proxyPass = "http://${config.services.netbox.listenAddress}:${
            toString config.services.netbox.port
          }";
        # extraConfig = ''
        #   rewrite /netbox(.*) $1 break;
        # '';
      };
    };
  };
}
