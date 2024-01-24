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
    headless.enable = true;
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
      };
    };
    disks.ext4 = {
      enable = true;
      main = "/dev/disk/by-id/virtio-vdisk1";
    };
    security.ipa = {
      enable = lib.mkForce false;
    };
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
          image = "docker.io/freeipa/freeipa-server:almalinux-9";
          autoStart = true;
          ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          hostname = "ipa.harkema.io";
          extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0" "-e" "SECRET=Secret123" "-e" "PASSWORD=Secret123"];
          cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
          volumes = [
            "/var/lib/freeipa:/data:Z"
          ];
        };
      };
    };

    boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1"];
    # boot.kernelPackages = pkgs.linuxPackages_latest;

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
