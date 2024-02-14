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
    # NixOS wants to enable GRUB by default
    boot.loader.grub.enable = false;
    boot.loader.systemd-boot.enable = lib.mkForce false;

    services.openssh.enable = true;
    services.avahi.enable = true;
    console.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypifw
      bluez
    ];

    systemd.services.attic-watch.enable = lib.mkForce false;

    resilio.enable = false;
    services.promtail = {
      enable = lib.mkForce false;
    };

    # system.stateVersion = "23.11";

    services.avahi.extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    services.avahi.publish.userServices = true;

    hardware = {
      enableRedistributableFirmware = true;
      firmware = [pkgs.wireless-regdb];
    };

    networking.networkmanager.enable = false;

    # boot.loader.raspberryPi.firmwareConfig = ''
    #   dtparam=audio=on
    # '';

    # Networking
    networking = {
      useDHCP = true;
      interfaces.wlan0 = {
        useDHCP = true;
      };
      interfaces.eth0 = {
        useDHCP = true;
      };

      # Enabling WIFI
      wireless = {
        enable = true;
        interfaces = ["wlan0"];
        networks."Have a good day".pskRaw = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
      };
    };
    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;
  };
}
