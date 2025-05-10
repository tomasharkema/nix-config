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
    system.build.input-wacom = pkgs.custom.input-wacom.override {kernel = config.boot.kernelPackages.kernel;};

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

      udev.packages = with pkgs; [imsprog];
    };

    hardware = {
      sensor.iio.enable = true;
      usbStorage.manageShutdown = true;
    };

    programs = {
      gphoto2.enable = true;
      nm-applet.enable = true;
    };

    boot = {
      kernelParams = [
        "preempt=lazy"

        "delayacct"
      ];

      # kernelModules = ["wacom"];

      # extraModulePackages = [
      #   config.system.build.input-wacom
      # ];
    };

    environment.systemPackages = with pkgs; [
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
      imsprog
      gphoto2
      gphoto2fs
      gphotos-sync
      blueberry
      (lib.mkIf pkgs.stdenv.isx86_64 arduino-ide)
    ];
  };
}
