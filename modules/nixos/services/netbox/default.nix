{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.netbox;
in {
  options.apps.netbox = {
    enable = lib.mkEnableOption "enable netbox-service";
  };

  config = lib.mkIf (cfg.enable && false) {
    age.secrets.netbox = {
      rekeyFile = ./netbox.age;
      group = "netbox";
      owner = "netbox";
    };

    systemd.services.netbox = {serviceConfig = {TimeoutSec = 900;};};

    users.users.nginx.extraGroups = ["netbox"];
    users.users.netbox.extraGroups = ["nginx"];

    services = {
      netbox = {
        enable = true;
        secretKeyFile = config.age.secrets.netbox.path;
        listenAddress = "127.0.0.1";
        port = 8001;
        settings.ALLOWED_HOSTS = ["netbox.ling-lizard.ts.net"];
      };

      nginx = {
        enable = true;
        # user = "netbox";
        # recommendedTlsSettings = true;
        clientMaxBodySize = "25m";

        virtualHosts."netbox.ling-lizard.ts.net" = {
          listen = [
            {
              port = 8002;
              addr = "0.0.0.0";
            }
          ];
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:8001";
              # proxyPass = "http://${config.services.netbox.listenAddress}:${config.services.netbox.port}";
            };
            "/static/" = {alias = "${config.services.netbox.dataDir}/static/";};
          };
        };
      };
    };
  };
}
