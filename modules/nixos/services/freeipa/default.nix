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
    services.podman.enable = true;

    virtualisation = {
      oci-containers.containers = {
        free-ipa-tailscale = {
          image = "docker.io/tailscale/tailscale:stable";
          hostname = "${config.networking.hostName}-freeipa-tailscale.harkema.intra";
          autoStart = true;
          extraOptions = [
            "--device=/dev/net/tun:/dev/net/tun"
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
          ];
          environment = {
            TS_HOSTNAME = "${config.networking.hostName}-freeipa-tailscale.harkema.intra";
            TS_STATE_DIR = "/var/lib/tailscale";
            TS_ROUTES = "10.88.0.0/16";
          };
          volumes = [
            "/var/lib/tailscale-free-ipa:/var/lib/tailscale:Z"
          ];
        };
        free-ipa = {
          dependsOn = ["free-ipa-tailscale"];
          image = "docker.io/freeipa/freeipa-server:fedora-39";
          autoStart = true;
          #ports = ["53:53" "53:53/udp" "80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "ipa.harkema.intra";
          extraOptions = [
            "--network=container:free-ipa-tailscale"
          ];
          environment = {
            SECRET = "Secret123!";
            PASSWORD = "Secret123!";
          };
          #cmd = ["/bin/bash" "-c" "yum install epel-release -y && yum install letsencrypt git -y && ipa-server-install -U -r HARKEMA.IO"];
          cmd = [
            "ipa-server-install"
            "-U"
            "--realm=HARKEMA.INTRA"
            "--hostname=ipa.harkema.intra"
            "--setup-dns"
            "--no-forwarders"
            "--no-host-dns"
            "--ip-address=100.76.50.114"
          ];
          volumes = [
            "/var/lib/freeipa:/data:Z"
          ];
        };
      };
    };

    # proxy-services.enable = false;

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
    # security.ipa = {
    #   enable = lib.mkForce false;
    # };
  };
}
