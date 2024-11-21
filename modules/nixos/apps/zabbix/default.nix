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

  config = lib.mkIf cfgServer.enable {
    containers.zabbix = {
      autoStart = true;

      privateNetwork = true;
      hostBridge = "br0"; # Specify the bridge name
      localAddress = "192.168.110.5/24";

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

          tailscale = {enable = true;};
        };

        networking = {
          hostName = "zabbix";
        };
      };
    };
  };
}
