{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.freeipa;
in {
  options.services.freeipa = {enable = lib.mkEnableOption "freeipa";};

  config = lib.mkIf cfg.enable {
    apps = {
      ipa.enable = false;

      podman.enable = true;
    };

    networking = {firewall = {trustedInterfaces = ["veth0" "veth1"];};};

    virtualisation = {
      podman = {
        defaultNetwork.settings = lib.mkForce {
          subnets = [
            {
              gateway = "10.87.0.1";
              subnet = "10.87.0.0/16";
            }
          ];
        };
      };

      oci-containers.containers = {
        free-ipa-tailscale = {
          image = "docker.io/tailscale/tailscale:stable";
          hostname = "ipa.harkema.intra";
          autoStart = true;
          extraOptions = [
            "--device=/dev/net/tun:/dev/net/tun"
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
          ];
          environment = {
            TS_HOSTNAME = "ipa.harkema.intra";
            TS_STATE_DIR = "/var/lib/tailscale";
            TS_ROUTES = "10.87.0.0/16";
          };
          volumes = ["/var/lib/tailscale-free-ipa:/var/lib/tailscale:Z"];
        };
        free-ipa = {
          dependsOn = ["free-ipa-tailscale"];
          image = "docker.io/freeipa/freeipa-server:fedora-39";
          autoStart = true;
          hostname = "ipa.harkema.intra";
          extraOptions = [
            "--network=container:free-ipa-tailscale"
            # "-p=389:389"
          ];
          environment = {
            # DEBUG_NO_EXIT = "1";
          };
          cmd = [
            "ipa-server-install"
            "-U"
            "--realm=HARKEMA.INTRA"
            "--hostname=ipa.harkema.intra"
            "--setup-dns"
            "--no-forwarders"
            "--ip-address=100.76.50.114"
            "--ds-password=Secret123!"
            "--admin-password=Secret123!"
          ];
          volumes = ["/var/lib/freeipa:/data:Z"];
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
