{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.gui;
in {
  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/desktops/seatd.nix"
  # ];

  options.gui = {enable = mkEnableOption "gui.defaults";};

  config = mkIf cfg.enable {
    gui = {
      gamemode.enable = mkDefault false;
      quiet-boot.enable = mkDefault true;
      desktop.enable = mkDefault true;
      gnome.enable = mkDefault true;
    };
    apps.flatpak.enable = mkDefault true;

    services = {
      ddccontrol.enable = true;
      seatd.enable = true;
    };
    environment.systemPackages = with pkgs; [
    ];
  };
}
