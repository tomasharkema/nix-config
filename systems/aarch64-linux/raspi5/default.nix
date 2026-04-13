{
  pkgs,
  inputs,
  lib,
  ...
}: {
  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5nG9yiypS+gwCs5jCm3OyTt4v693iR/OcHuJ0aaD4W root@raspi5";
    };

    hardware = {
      # enableRedistributableFirmware = true;
      i2c.enable = true;

      # deviceTree = {
      #   enable = true;
      #   filter = "*rpi*";
      # };
    };

    boot = {
      #   loader.raspberryPi.firmwarePackage = kernelBundle.raspberrypifw;
      #   loader.raspberryPi.bootloader = "kernel";
      #   kernelPackages = kernelBundle.linuxPackages_rpi5;

      # kernelParams = [
      #   "console=ttyS0,115200"
      #   "console=ttyAMA10,115200"
      # ];

      loader.raspberry-pi = {
        variant = "5";
        bootloader = "kernel";
        #   firmwarePackage =
        #     inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.raspberrypifw;
      };

      # kernelPackages =
      # inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi5;

      # initrd.availableKernelModules = [
      #   "nvme" # nvme drive connected with pcie
      # ];
    };

    networking = {
      hostName = lib.mkForce "raspi5-2";
      firewall.enable = false;
      networkmanager.enable = true;
    };

    zramSwap = {
      enable = true;
    };

    fileSystems = {
      "/boot/firmware" = {
        device = "/dev/disk/by-label/FIRMWARE";
        fsType = "vfat";
        options = [
          "noatime"
          "noauto"
          "x-systemd.automount"
          "x-systemd.idle-timeout=1min"
        ];
      };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    hardware.raspberry-pi.config = {
      all = {
        options = {
          enable_uart = {
            enable = true;
            value = true;
          };
          uart_2ndstage = {
            enable = true;
            value = true;
          };
        };
        base-dt-params = {
          pciex1 = {
            enable = true;
            value = "on";
          };
          pciex1_gen = {
            enable = true;
            value = "3";
          };
        };
      };
    };

    services.kdump.enable = lib.mkForce false;

    swapDevices = [
      {
        device = "/swapfile";
        size = 16 * 1024;
      }
    ];

    traits = {
      low-power.enable = true;
      hardware = {
        # raspberry.enable = true;
        # bluetooth.enable = true;
      };
    };
  };
}
