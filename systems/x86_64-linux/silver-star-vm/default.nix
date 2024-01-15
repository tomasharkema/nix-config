{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    networking.hostName = "silver-star-vm";

    services.resilio = {
      enable = lib.mkForce false;
    };
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
      };
    };
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/virtio-vdisk1";
    };

    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;

        autoPrune.enable = true;
        # networkSocket.enable = true;
      };
      oci-containers.backend = "podman";
      oci-containers.containers = {
        free-ipa = {
          image = "docker.io/freeipa/freeipa-server:rocky-9";
          autoStart = true;
          ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "ipa.harkema.io";
          extraOptions = ["--read-only" "-e" "PASSWORD=Secret123"];
          cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO" "--no-ntp" "--ca-subject" "CN=harkema.io"];
          volumes = [
            "/mnt/shared/freeipa:/data:Z"
          ];
        };
      };
    };

    boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1"];
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.firewall.enable = lib.mkForce false;
    networking.nftables.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkDefault false;
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkForce true;

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    fileSystems."/mnt/shared" = {
      fsType = "virtiofs";
      device = "appdata_ssd";
    };
  };
}
