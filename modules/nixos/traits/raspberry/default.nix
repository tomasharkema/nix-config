{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.raspberry;
in {
  options.traits.raspberry = {
    enable = lib.mkEnableOption "SnowflakeOS GNOME configuration";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.vmVariant = {
      virtualisation = {
        cores = 4;
        memorySize = 4 * 1024;
        diskSize = 50 * 1024;
      };
    };

    hardware = {
      enableRedistributableFirmware = true;
      i2c.enable = true;
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
      deviceTree = {
        enable = true;
        filter = "*rpi*.dtb";
      };
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
      "/boot/firmware" = {
        device = "/dev/disk/by-label/FIRMWARE";
        fsType = "vfat";
      };
    };

    # requires initrd systemd
    # system.etc.overlay = {
    #   enable = true;
    #   mutable = true;
    # };

    boot = {
      # kernelParams = [
      #   "console=tty1"
      # ];
      # kernelModules = ["dwc2" "g_serial"];
      kernelParams = [
        "console=serial0,115200n8"
        "console=ttyS0,115200n8"
        "console=ttyS1,115200n8"
      ];

      consoleLogLevel = lib.mkDefault 7;

      initrd.availableKernelModules = [
        "usbhid"
        "usb_storage"
        "vc4"
        "pcie_brcmstb" # required for the pcie bus to work
        "reset-raspberrypi" # required for vl805 firmware to load
      ];

      tmp = {
        useTmpfs = false;
        cleanOnBoot = true;
      };
      loader = {
        grub.enable = false;
        systemd-boot.enable = lib.mkForce false;
        generic-extlinux-compatible = {
          enable = lib.mkDefault true;
          useGenerationDeviceTree = false;
        };
      };
    };

    security = {
      audit.enable = lib.mkForce false;
      auditd.enable = lib.mkForce false;
    };

    programs = {
      atop.enable = lib.mkForce false;
    };

    services = {
      locate.enable = lib.mkForce false;
      fwupd.enable = lib.mkForce false;
      smartd.enable = lib.mkForce false;
      beszel.enable = lib.mkForce false;
      keybase = {
        enable = lib.mkForce true;
      };

      kbfs = {
        enable = lib.mkForce true;
      };
    };

    # sdImage.compressImage = false;

    # gui."media-center".enable = true;

    # services = {
    #   openssh.enable = true;
    #   avahi = {
    #     enable = true;
    #     publish.userServices = true;
    #     extraServiceFiles = {
    #       ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    #     };
    #   };

    #   promtail = {
    #     enable = lib.mkForce false;
    #   };
    #   blueman.enable = true;
    # };
    # console.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypifw
      bluez
    ];

    swapDevices = [
      {
        device = "/swapfile";
        size = 8 * 1024;
      }
    ];

    apps.resilio.enable = false;

    # system.stateVersion = "25.05";

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    # boot.loader.raspberryPi.firmwareConfig = ''
    #   dtparam=audio=on
    # '';

    networking = {
      networkmanager.enable = true;
      # useDHCP = false;
      # interfaces.wlan0 = {
      #   useDHCP = true;
      # };
      # interfaces.eth0 = {
      #   useDHCP = true;
      # };

      # Enabling WIFI
      # wireless = {
      # enable = true;
      #   interfaces = ["wlan0"];
      #   networks."Have a good day".pskRaw = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      # };
    };
  };
}
