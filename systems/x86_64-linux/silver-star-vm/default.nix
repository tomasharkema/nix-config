{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
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

    resilio.enable = mkForce false;
    # apps.tor.relay.enable = true;

    services = {
      netbox-service.enable = true;

      freeipa.enable = true;

      resilio.enable = lib.mkForce false;

      ha.initialMaster = true;

      command-center = {
        enableBot = true;
      };
    };

    networking = {
      hostName = "silver-star-vm";

      firewall.enable = true;
      nftables.enable = true;
      # wireless.enable = lib.mkDefault false;
      networkmanager.enable = true;

      useDHCP = false;
      interfaces."enp3s0".useDHCP = true;
    };

    # sudo mount --types virtiofs appdata_ssd /mnt/shared/
    # fileSystems."/mnt/shared" = {
    #   fsType = "virtiofs";
    #   device = "appdata_ssd";
    # };
  };
}
