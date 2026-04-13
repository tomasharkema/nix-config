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
      i2c.enable = true;
    };

    boot = {
      loader.raspberry-pi = {
        variant = "5";
        bootloader = "kernel";
      };
      kernelPackages = pkgs.linuxPackagesFor (inputs.nixos-raspberrypi.packages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_rpi5.kernel.override {stdenv = pkgs.ccacheStdenv;});
    };

    environment.systemPackages = with pkgs; [
      custom.rpifwcrypto-pkcs11
    ];

    networking = {
      hostName = lib.mkForce "raspi5-2";
      firewall.enable = false;
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
        };
      };
      wireless = {
        enable = false;
        iwd = {
          enable = true;
          settings = {
            Settings = {
              AutoConnect = true;
              # AlwaysRandomizeAddress = false;
            };
            Network = {
              # EnableIPv6 = true;
              # RoutePriorityOffset = 300;
            };
            # DriverQuirks.DefaultInterface = "wlan0";
          };
        };
      };
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
          # pciex1 = {
          #   enable = true;
          #   value = "on";
          # };
          # pciex1_gen = {
          #   enable = true;
          #   value = "3";
          # };
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
