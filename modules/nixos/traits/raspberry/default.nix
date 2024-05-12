{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.raspberry;
in {
  options.traits = {
    raspberry = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.vmVariant = {
      virtualisation = {
        cores = 4;
        memorySize = 4 * 1024;
        diskSize = 50 * 1024;
      };
    };

    fileSystems = {
      "/boot" = {
        device = "/dev/disk/by-label/NIXOS_BOOT";
        fsType = "vfat";
      };
      "/" = {
        device = "/dev/disk/by-label/NIXOS_SD";
        fsType = "ext4";
      };
    };

    boot = {
      # kernelParams = [
      #   "console=tty1"
      # ];
      kernelModules = ["dwc2" "g_serial"];
      # kernelParams = ["console=tty0"];

      tmp = {
        useTmpfs = false;
        cleanOnBoot = false;
      };
    };

    services.fwupd.enable = true;

    # NixOS wants to enable GRUB by default
    boot.loader = {
      grub.enable = false;
      systemd-boot.enable = mkForce false;
      generic-extlinux-compatible.enable = mkDefault true;
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
    #     enable = mkForce false;
    #   };
    #   blueman.enable = true;
    # };
    # console.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypifw
      bluez
    ];

    systemd.services.attic-watch.enable = mkForce false;
    resilio.enable = false;

    # system.stateVersion = "23.11";

    hardware = {
      enableRedistributableFirmware = true;
      firmware = [pkgs.wireless-regdb];
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
      wireless = {
        enable = false;
        #   interfaces = ["wlan0"];
        #   networks."Have a good day".pskRaw = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      };
    };
  };
}
