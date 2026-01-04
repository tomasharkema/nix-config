{
  pkgs,
  inputs,
  lib,
  modulesPath,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIN/5vuqA+Pnjl5lNUIs6sJapHiuevrHZftMPiP8EdpO root@nixos";
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;

      deviceTree = {
        enable = true;
        filter = "*rpi*";
      };
    };

    boot = {
      #   loader.raspberryPi.firmwarePackage = kernelBundle.raspberrypifw;
      #   loader.raspberryPi.bootloader = "kernel";
      #   kernelPackages = kernelBundle.linuxPackages_rpi5;

      kernelParams = [
        "console=ttyS0,115200"
        "console=ttyAMA10,115200"
      ];
    };

    networking = {
      hostName = "raspi5";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    zramSwap = {enable = true;};

    fileSystems = {
      "/boot/firmware" = {
        device = "/dev/disk/by-label/FIRMWARE";
        fsType = "vfat";
      };
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
      low-power.enable = true;
      hardware = {
        raspberry.enable = true;
        bluetooth.enable = true;
      };
    };
  };
}
