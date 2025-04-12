{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    # nixos-hardware.nixosModules.raspberry-pi-4

    # nixos-generators.nixosModules.all-formats
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGUTP5KhcV1yxEU58RGanzhh5x/mWVH5aGJVSPGz1r6B root@baaa-express";
    };

    networking = {
      hostName = "mimas";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      # "/" = {
      #   device = "/dev/disk/by-label/NIXOS_SD";
      #   fsType = "ext4";
      # };
    };
    traits.raspberry.enable = true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    traits = {
      low-power.enable = true;
      hardware.bluetooth.enable = true;
    };

    services = {
      remote-builders.client.enable = true;
      avahi = {
        enable = true;
      };
      adguardhome = {
        enable = true;
        openFirewall = true;
      };
    };

    # system.stateVersion = "25.05";

    # fileSystems."/".fsType = lib.mkForce "tmpfs";
    # fileSystems."/".device = lib.mkForce "none";
    zramSwap = {
      enable = false;
    };

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    programs.atop = {
      enable = lib.mkForce false;
    };

    boot = {
      loader = {
        grub.enable = lib.mkDefault false;
        generic-extlinux-compatible.enable = lib.mkDefault true;
      };

      initrd.kernelModules = [
        "vc4"
        "bcm2835_dma"
        "i2c_bcm2835"
        # "dwc2"
        # "g_serial"
      ];

      # kernelPackages = pkgs.linuxKernel.packages.linux_rpi3;

      kernelParams = lib.mkForce [
        # "console=ttyS0,115200n8"
        "console=ttyS1,115200n8"
        # "console=tty0"
        "cma=320M"
      ];
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;
    };
  };
}
