{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gui;
in {
  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/desktops/seatd.nix"
  # ];

  options.gui = {
    enable = lib.mkEnableOption "gui.defaults";

    hidpi.enable = lib.mkEnableOption "enable gnome desktop environment";
  };

  config = lib.mkIf cfg.enable {
    system.build = {
      input-wacom = pkgs.custom.input-wacom.override {kernel = config.boot.kernelPackages.kernel;};
      i2c-ch341-usb = pkgs.custom.i2c-ch341-usb.override {kernel = config.boot.kernelPackages.kernel;};
    };

    gui = {
      gamemode.enable = lib.mkDefault false;
      quiet-boot.enable = lib.mkDefault true;
      desktop.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault true;
    };

    users.users.tomas.extraGroups = ["camera"];

    apps.flatpak.enable = lib.mkDefault true;

    services = {
      ddccontrol.enable = true;
      seatd.enable = true;
      printing.enable = true;
      mpd.enable = true;
      mopidy.enable = true;
      playerctld.enable = true;
      displayManager.defaultSession = "hyprland";
      g810-led = {
        enable = true;
        profile = ''
          # G810-LED Profile (turn all keys on)

          # Set all keys on
          a ffffff

          c";
        '';
      };
      # automatic-timezoned.enable = true;
      udev.packages = with pkgs; [imsprog logitech-udev-rules];
    };

    hardware = {
      sensor.iio.enable = true;
      usbStorage.manageShutdown = true;
      flipperzero.enable = true;
      logitech = {
        enable = true;
        enableGraphical = true;
        wireless = {
          enable = true;
          enableGraphical = true;
        };
      };
    };

    programs = {
      gphoto2.enable = true;
      nm-applet.enable = true;
    };

    # systemd = {enableEmergencyMode = lib.mkDefault true;};

    boot = {
      kernelParams = [
        "preempt=lazy"

        "delayacct"
      ];

      kernelModules = [
        "wacom"
        "spi-ch341-usb"
      ];

      extraModulePackages = [
        config.system.build.input-wacom
        config.system.build.i2c-ch341-usb
      ];
    };

    environment.systemPackages = with pkgs; [
      ddrescue
      ddrescueview
      ddrutility
      darktable
      rpi-imager
      custom.netsleuth
      handbrake
      thonny
      coppwr
      custom.meshtastic
      libwacom
      chromium
      noti
      ghex
      solaar
      solana-cli
      imsprog
      gphoto2
      gphoto2fs
      gphotos-sync
      blueberry
      custom.spi-tools
      qFlipper
      (lib.mkIf pkgs.stdenv.isx86_64 arduino-ide)
    ];
  };
}
