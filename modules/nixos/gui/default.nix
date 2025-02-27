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
    gui = {
      gamemode.enable = lib.mkDefault false;
      quiet-boot.enable = lib.mkDefault true;
      desktop.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault true;
    };
    apps.flatpak.enable = lib.mkDefault true;

    services = {
      ddccontrol.enable = true;
      seatd.enable = true;
      printing.enable = true;
      mpd.enable = true;
      mopidy.enable = true;
      playerctld.enable = true;
      displayManager.defaultSession = "hyprland";
    };

    boot.kernelParams = [
      "preempt=lazy"

      "delayacct"
    ];

    environment.systemPackages = with pkgs; [
      coppwr
    ];
  };
}
