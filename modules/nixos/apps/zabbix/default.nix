{
  pkgs,
  config,
  lib,
  ...
}: let
  cfgServer = config.apps.zabbix.server;
in {
  options.apps.zabbix = {
    server.enable = lib.mkEnableOption "zabbix server";
  };

  config = {
    # networking = {
    #   useNetworkd = true;
    #   networkmanager.enable = lib.mkForce false;
    # };

    services = {
      zabbixAgent = {
        enable = true;
        server = "silver-star";
        settings = {
          ServerActive = "silver-star";
        };
      };

      zabbixServer = lib.mkIf cfgServer.enable {
        enable = true;
      };
      tsnsrv = {
        services = {
          zabbix = {
            toURL = "https://127.0.0.1";
            upstreamHeaders = {
              Host = "zabbix.ling-lizard.ts.net";
            };
          };
        };
      };

      zabbixWeb = lib.mkIf cfgServer.enable {
        enable = true;
        frontend = "nginx";
        virtualHost = {
          hostName = "zabbix.ling-lizard.ts.net";
          adminAddr = "webmaster@localhost";
        };
      };
    };
  };
}
