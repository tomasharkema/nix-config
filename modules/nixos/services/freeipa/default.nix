{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.freeipa;
in {
  options.services.freeipa = {
    enable = mkEnableOption "freeipa";
  };

  config = mkIf cfg.enable {
    apps.podman.enable = true;

    virtualisation = {
      oci-containers.containers = {
        # golinks = {
        #   image = "ghcr.io/tomasharkema/golinks:latest";
        #   autoStart = true;
        #   ports = ["8000:8000"];
        #   environment = {
        #     BIND = "0.0.0.0:8000";
        #     BASEURL = "https://golinks.harkema.io";
        #   };
        # };
        free-ipa = {
          image = "docker.io/freeipa/freeipa-server:fedora-39";
          autoStart = true;
          ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "ipa.harkema.io";
          extraOptions = [
            "--sysctl"
            "net.ipv6.conf.all.disable_ipv6=0"
            "-e"
            "SECRET=Secret123"
            "-e"
            "PASSWORD=Secret123"
          ];
          #cmd = ["/bin/bash" "-c" "yum install epel-release -y && yum install letsencrypt git -y && ipa-server-install -U -r HARKEMA.IO"];
          cmd = [
            "ipa-server-install"
            "-U"
            "-r"
            "HARKEMA.IO"
            "--no-host-dns"
            "--hostname=ipa.harkema.io"
            "--ip-address=192.168.0.15"
          ];
          volumes = [
            "/var/lib/freeipa:/data:Z"
            "/var/lib/freeipa-ssl:/etc/ssl/ipa.harkema.io:Z"
            "/var/lib/freeipa-letsencrypt:/etc/letsencrypt:Z"
          ];
        };
      };
    };

    proxy-services.enable = false;

    # services.nginx = {
    #   enable = lib.mkForce false;
    # virtualHosts = {
    #   "ipa.harkema.io" = {
    #     locations."/".proxyPass = "https://127.0.0.1:3443";
    #   };
    # };
    # };

    # sudo podman exec free-ipa /data/root/freeipa-letsencrypt/renew-le.sh

    # systemd = {
    #   services."podman-freeipa-renew-le" = {
    #     script = ''
    #       ${pkgs.podman}/bin/podman exec free-ipa /data/root/freeipa-letsencrypt/renew-le.sh
    #     '';
    #     serviceConfig = {
    #       Type = "oneshot";
    #     };
    #   };

    #   timers."podman-freeipa-renew-le" = {
    #     wantedBy = ["timers.target"];
    #     timerConfig = {
    #       OnUnitActiveSec = "5m";
    #       Unit = "podman-freeipa-renew-le.service";

    #       OnCalendar = "daily";
    #       Persistent = true;
    #     };
    #   };
    # };

    boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1"];
    security.ipa = {
      enable = lib.mkForce false;
    };
  };
}
