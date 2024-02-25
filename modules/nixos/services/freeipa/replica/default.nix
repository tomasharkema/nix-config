{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.freeipa.replica;
in {
  options.services.freeipa.replica = {
    enable = mkEnableOption "freeipa replica";
  };

  config = mkIf cfg.enable {
    services.podman.enable = true;
    system.nixos.tags = ["freeipa-replica"];

    virtualisation = {
      podman = {
        defaultNetwork.settings = mkForce {
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
          hostname = "${config.networking.hostName}-replica-tailscale.harkema.intra";
          autoStart = true;
          extraOptions = [
            # "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
            "--device=/dev/net/tun:/dev/net/tun"
            "--cap-add=NET_ADMIN"
            "--cap-add=NET_RAW"
            # "--dns=1.1.1.1"
          ];
          environment = {
            TS_HOSTNAME = "${config.networking.hostName}-replica-tailscale.harkema.intra";
            TS_STATE_DIR = "/var/lib/tailscale";
          };
          volumes = [
            "/var/lib/tailscale-free-ipa-replica:/var/lib/tailscale:Z"
          ];
        };
        free-ipa-replica = {
          dependsOn = ["free-ipa-replica-tailscale"];
          image = "docker.io/freeipa/freeipa-server:fedora-39";
          autoStart = true;
          #ports = ["53:53" "53:53/udp" "80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "${config.networking.hostName}-replica.harkema.intra";
          extraOptions = [
            # "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
            "--network=container:free-ipa-replica-tailscale"
            # "--add-host=ipa.harkema.intra:100.64.198.108"
          ];
          environment = {
            DEBUG_NO_EXIT = "1";
          };
          cmd = [
            "ipa-replica-install"
            "--server=ipa.harkema.intra"
            "--domain=harkema.intra"
            "--principal=admin"
          ];
          volumes = [
            "/var/lib/freeipa-replica:/data:Z"
          ];
        };
      };
    };
  };
}
