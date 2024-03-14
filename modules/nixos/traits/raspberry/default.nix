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
      kernelParams = [
        "console=ttyS1,115200n8"
      ];
      kernelModules = ["dwc2" "g_serial"];

      tmp = {
        useTmpfs = false;
        cleanOnBoot = true;
      };
    };

    zramSwap = {
      enable = false;
    };

    # NixOS wants to enable GRUB by default
    boot.loader = {
      grub.enable = false;
      systemd-boot.enable = mkForce false;
    };
    # boot.loader.generic-extlinux-compatible.enable = true;

    # sdImage.compressImage = false;

    services = {
      openssh.enable = true;
      avahi = {
        enable = true;
        publish.userServices = true;
        extraServiceFiles = {
          ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
        };
      };

      promtail = {
        enable = mkForce false;
      };
      blueman.enable = true;
    };
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

    networking.wireless.enable = true;

    networking = {
      networkmanager.enable = false;

      useDHCP = false;
      interfaces.wlan0 = {
        useDHCP = true;
      };
      interfaces.eth0 = {
        useDHCP = true;
      };

      # Enabling WIFI
      # wireless = {
      #   enable = true;
      #   interfaces = ["wlan0"];
      #   networks."Have a good day".pskRaw = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      # };
    };
  };
}
