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

    fileSystems = {
      # "/boot" = {
      #   device = "/dev/disk/by-label/NIXOS_BOOT";
      #   fsType = "vfat";
      # };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
      # "/boot/firmware" = {
      #   device = "/dev/disk/by-label/FIRMWARE";
      #   fsType = "fat";
      # };
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
      # kernelParams = ["console=tty0"];
      consoleLogLevel = lib.mkDefault 7;

      tmp = {
        useTmpfs = false;
        cleanOnBoot = false;
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

    apps.resilio.enable = false;

    # system.stateVersion = "25.05";

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    hardware = {
      enableRedistributableFirmware = true;
      # firmware = [pkgs.wireless-regdb];
      bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
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
