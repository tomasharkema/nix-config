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

  config = lib.mkIf false {
    # networking = {
    #   useNetworkd = true;
    #   networkmanager.enable = lib.mkForce false;
    # };

    services = {
      zabbixAgent = {
        # enable = true;
        server = "silver-star";
        settings = {
          ServerActive = "silver-star";
        };
      };

      zabbixServer = {
        enable = true;
      };

      zabbixWeb = {
        enable = true;
        virtualHost = {
          hostName = "zabbix.localhost";
          adminAddr = "webmaster@localhost";
        };
      };
    };
  };
}
