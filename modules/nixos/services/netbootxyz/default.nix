{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.netbootxyz;

  docker-ps = pkgs.writeShellScriptBin "docker-ps" ''

    ctnr="$1"

    ${pkgs.docker}/bin/docker ps --filter "status=running" | \
    ${pkgs.gnugrep}/bin/grep -i "$ctnr" > /dev/null

    if [ $? -eq 0 ]; then
      exit 0  # Process is running
    else
      exit 1  # Process is not running
    fi
  '';
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
      };
      "/export/tftpboot" = {
        device = "/mnt/tftpboot";
        options = ["bind"];
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

          virtualIps = [{addr = "192.168.0.250/24";}];
          trackScripts = ["track_netbootxyz"];
        };

        vrrpScripts = {
          track_netbootxyz = {
            # Note: Shell pipes are not supported here. Call a self written
            # script or something like that instead.
            script = "${docker-ps}/bin/docker-ps netbootxyz";
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
          WEB_APP_PORT = "3001"; #optional
          NGINX_PORT = "8083";
        };
        ports = [
          "3001:3001"
          "69:69/udp"
          "8083:8083"
        ];
      };
    };
  };
}
