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

  options.gui = {enable = lib.mkEnableOption "gui.defaults";};

  config = lib.mkIf cfg.enable {
    gui = {
      gamemode.enable = lib.mkDefault false;
      quiet-boot.enable = lib.mkDefault true;
      desktop.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault true;
    };
    apps.flatpak.enable = lib.mkDefault true;

    services = {
      # ddccontrol.enable = true;
      seatd.enable = true;
    };
    environment.systemPackages = with pkgs; [
    ];
  };
}
