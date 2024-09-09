{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.freeipa.replica;
  hostHostName = config.networking.hostName;
  hostConfig = config;
in {
  options.services.freeipa.replica = {
    enable = lib.mkEnableOption "freeipa replica";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["freeipa-replica"];

    # networking.nat = {
    #   enable = true;
    #   internalInterfaces = ["ve-+"];
    #   externalInterface = "eno1";
    #   # Lazy IPv6 connectivity for the container
    #   enableIPv6 = false;
    # };

    # containers.freeipa-replica = {
    #   autoStart = true;
    #   # privateNetwork = true;

    #   # localAddress = "10.90.0.11";
    #   # hostAddress = "10.90.0.10";

    #   enableTun = true;

    #   config = {
    #     config,
    #     pkgs,
    #     ...
    #   }: {
    #     environment.systemPackages = with pkgs; [freeipa];

    #     system.stateVersion = "24.11";

    #     networking = {
    #       hostName = "${hostHostName}-replica";

    #       firewall = {
    #         enable = false; # true;
    #         # allowedTCPPorts = [80];
    #       };
    #       # Use systemd-resolved inside the container
    #       # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
    #       useHostResolvConf = mkForce false;
    #       # iptables.enable = true;
    #     };

    #     services = {
    #       resolved.enable = true;

    #       tailscale = {
    #         enable = true;
    #         authKeyFile = hostConfig.age.secrets.tailscale.path;
    #         # useRoutingFeatures = "client";
    #         extraUpFlags = [
    #           # "--advertise-tags=tag:nixos"
    #           "--operator=tomas"
    #           "--accept-dns"
    #           "--accept-routes"
    #         ];
    #         openFirewall = true;
    #       };
    #     };
    #   };
    # };

    apps.podman.enable = true;

    virtualisation = {
      podman = {
        defaultNetwork.settings = lib.mkForce {
          subnets = [
            {
              gateway = "10.89.0.1";
              subnet = "10.89.0.0/16";
            }
          ];
        };
      };
      oci-containers.containers = {
        free-ipa-replica-tailscale = {
          image = "docker.io/tailscale/tailscale:stable";
          hostname = "${config.networking.hostName}-replica.harkema.intra";
          autoStart = true;
          extraOptions = [
            "--device=/dev/net/tun:/dev/net/tun"
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
          ];
          environment = {
            TS_HOSTNAME = "${config.networking.hostName}-replica.harkema.intra";
            TS_STATE_DIR = "/var/lib/tailscale";
            # TS_EXTRA_ARGS = "--accept-routes --accept-dns";
          };
          volumes = ["/var/lib/tailscale-free-ipa-replica:/var/lib/tailscale:Z"];
        };
        free-ipa-replica = {
          dependsOn = ["free-ipa-replica-tailscale"];
          image = "docker.io/freeipa/freeipa-server:fedora-39";
          autoStart = true;
          #ports = ["53:53" "53:53/udp" "80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "${config.networking.hostName}-replica.harkema.intra";
          extraOptions = ["--network=container:free-ipa-replica-tailscale"];
          environment = {DEBUG_NO_EXIT = "1";};
          cmd = [
            "ipa-replica-install"
            "-U"
            "--server=ipa.harkema.infra"
            "-P"
            "admin@HARKEMA.INTRA"
            "--domain=harkema.intra"
            # "-w"
            # "$(cat /run/otp/otp)"
            # "ipa-replica-install"
            # "--server=ipa.harkema.intra"
            # "--domain=harkema.intra"
            # "--principal=admin"
          ];
          volumes = [
            "/var/lib/freeipa-replica:/data:Z"
            # "/run/otp:/run/otp:ro"
          ];
        };
      };
    };
  };
}
