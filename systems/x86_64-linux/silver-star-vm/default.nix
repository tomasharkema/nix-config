{lib, ...}: {
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
      };
      oci-containers.backend = "podman";
      oci-containers.containers = {
        free-ipa = {
          image = "freeipa/freeipa-server:rocky-9";
          autoStart = true;
          ports = ["6443:443"];
          hostname = "ipa.harkema.io";
          environment = {
            PASSWORD = "derp";
          };
        };
      };
    };

    boot.bootspec.enable = true;
    boot.kernelParams = ["systemd.unified_cgroup_hierarchy=1"];

    networking.firewall.enable = false;
    networking.nftables.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkDefault false;
  };
}
