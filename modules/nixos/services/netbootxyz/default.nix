{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.netbootxyz;
  webPort = "3001";
in {
  options.services.netbootxyz = {
    enable = lib.mkEnableOption "netbootxyz";
  };

  config = lib.mkIf cfg.enable {
    apps.docker.enable = true;

    fileSystems = {
      "/export/netboot" = {
        device = "/mnt/netboot";
        options = ["bind"];
        fsType = "none";
      };
      "/export/tftpboot" = {
        device = "/mnt/tftpboot";
        options = ["bind"];
        fsType = "none";
      };
    };

    services = {
      nfs = {
        server = {
          enable = true;
          exports = ''
            /export/netboot        *(rw,sync,no_subtree_check,no_root_squash)
            /export/tftpboot       *(rw,sync,no_subtree_check,no_root_squash)
          '';
        };
      };

      pixiecore = {
        enable = true;
        openFirewall = true;
        dhcpNoBind = true;
        kernel = "https://boot.netboot.xyz";
        mode = "api";
        port = 7849;
        statusPort = 7849;
        apiServer = "http://localhost:7847";
      };

      keepalived = {
        enable = true;

        openFirewall = true;

        snmp = {
          enable = true;
          enableTraps = true;
        };

        extraGlobalDefs = ''
          use_symlink_paths true
        '';

        vrrpInstances.VIP_32 = {
          state =
            if config.networking.hostName == "silver-star"
            then "MASTER"
            else "BACKUP";
          interface = "br0";
          virtualRouterId = 32;
          priority =
            if config.networking.hostName == "silver-star"
            then 51
            else 10;

          virtualIps = [
            {addr = "192.168.0.250/24";}
            # {addr = "192.168.1.250/24";}
            # {addr = "192.168.9.250/24";}
          ];
          trackScripts = ["track_netbootxyz"];
        };

        vrrpScripts = {
          track_netbootxyz = {
            # Note: Shell pipes are not supported here. Call a self written
            # script or something like that instead.
            script = ''
              nmap localhost -p ${webPort} | grep -q "${webPort}/tcp.*open"
            '';
            interval = 10;
            timeout = 2;
            rise = 2;
            fall = 2;
            weight = 10;
            user = "root";
          };
        };
      };

      snmpd = {
        enable = true;
        configText = ''
          master	agentx
          # System + hrSystem groups
          view   haproxyview   included   .1.3.6.1.2.1.1
          view   haproxyview   included   .1.3.6.1.2.1.25.1
          # HAProxy Enterprise groups
          view   haproxyview   included   .1.3.6.1.4.1.23263.4.3
          view   haproxyview   included   .1.3.6.1.4.1.58750.4.3
          rocommunity  haproxy default -V haproxyview
          rocommunity6 haproxy default -V haproxyview
        '';
      };
    };

    virtualisation.oci-containers.containers = {
      netbootxyz = {
        image = "ghcr.io/netbootxyz/netbootxyz:latest";

        autoStart = true;

        volumes = [
          "/var/lib/netboot/config:/config"
          "/var/lib/netboot/assets:/assets"
          "/mnt/netboot:/netboot"
        ];
        environment = {
          WEB_APP_PORT = "${webPort}";
          NGINX_PORT = "8083";
        };
        ports = [
          "${webPort}:${webPort}"
          "69:69/udp"
          "8083:8083"
        ];
      };
    };
  };
}
