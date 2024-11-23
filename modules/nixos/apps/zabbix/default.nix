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

    services.zabbixAgent = {
      enable = true;
      server = "silver-star";
      settings = {
        ServerActive = "silver-star";
      };
    };
    containers.zabbix = lib.mkIf false {
      enableTun = true;
      autoStart = true;
      # hostBridge = "br0";

      privateNetwork = true;
      hostBridge = "br0"; # Specify the bridge name
      localAddress = "192.168.0.102/24";

      config = {
        config,
        pkgs,
        lib,
        ...
      }: {
        services = {
          zabbixServer = {
            enable = true;
          };

          zabbixWeb = {
            enable = true;
          };

          # tailscale = {enable = true;};
        };

        networking = {
          hostName = "zabbix";
        };
      };
    };
  };
}
