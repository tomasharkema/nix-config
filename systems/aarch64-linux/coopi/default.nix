{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1YWKTdedduXBRefDk2melpN4UlkYZLi95xEY+jcni2 root@nixos";
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      deviceTree = {
        enable = true;
        filter = "*-rpi-zero-2-w*";
      };
    };

    networking = {
      hostName = "coopi";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    zramSwap = {enable = true;};

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    traits = {
      raspberry.enable = true;
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };
  };
}
