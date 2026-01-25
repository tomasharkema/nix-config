{
  pkgs,
  config,
  lib,
  ...
}: let
  cfgServer = config.apps.zabbix.server;
  cfgProxy = config.apps.zabbix.proxy;
in {
  options.apps.zabbix = {
    server.enable = lib.mkEnableOption "zabbix server";
    proxy.enable = lib.mkEnableOption "zabbix proxy";
  };

  config = {
    # networking = {
    #   useNetworkd = true;
    #   networkmanager.enable = lib.mkForce false;
    # };
    # environment.systemPackages = [pkgs.zabbix-cli pkgs.zabbixctl];

    users.groups.docker.members = ["zabbix-agent"];

    services = {
      zabbixAgent = {
        enable = true;
        server = "silver-star,127.0.0.1,silver-star.ling-lizard.ts.net,192.168.0.0/16";
        settings = {
          ServerActive = "silver-star.ling-lizard.ts.net";
        };
        package = pkgs.zabbix74.agent2;
      };

      zabbixProxy = lib.mkIf cfgProxy.enable {
        enable = true;
        server = "192.168.0.100";
        package = pkgs.zabbix74.proxy-sqlite;
        extraPackages = with pkgs; [net-tools nmap traceroute iputils];
        settings = {
          CacheSize = "1G";
          SSHKeyLocation = "/var/lib/zabbix/.ssh";
          StartPingers = 32;
        };
        openFirewall = true;
      };

      zabbixServer = lib.mkIf cfgServer.enable {
        enable = true;
        package = pkgs.zabbix74.server-pgsql;
        extraPackages = with pkgs; [net-tools nmap traceroute iputils];
        settings = {
          CacheSize = "1G";
          SSHKeyLocation = "/var/lib/zabbix/.ssh";
          StartPingers = 32;
        };
        openFirewall = true;
      };

      # zabbixProxy = lib.mkIf (cfgServer.enable) {
      #   enable = true;
      # };

      tsnsrv = lib.mkIf cfgServer.enable {
        services = {
          zabbix = {
            toURL = "http://127.0.0.1";
            upstreamHeaders = {
              Host = "zabbix.ling-lizard.ts.net";
            };
          };
        };
      };

      zabbixWeb = lib.mkIf cfgServer.enable {
        enable = true;
        # frontend = "nginx";
        hostname = "zabbix.ling-lizard.ts.net";
        # virtualHost = {
        #   hostName = "zabbix.ling-lizard.ts.net";
        #   adminAddr = "webmaster@localhost";
        # };
        package = pkgs.zabbix74.web;
      };

      phpfpm.pools.zabbix = lib.mkIf cfgServer.enable {
        phpPackage = pkgs.php83;
      };
    };
  };
}
