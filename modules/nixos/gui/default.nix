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
  imports = [
    "${inputs.unstable}/nixos/modules/services/desktops/seatd.nix"
  ];

  options.gui = {
    enable = mkEnableOption "gui.defaults";
  };

  config = mkIf cfg.enable {
    gui = {
      game-mode.enable = mkDefault false;
      quiet-boot.enable = mkDefault true;
      desktop.enable = mkDefault true;
      gnome.enable = mkDefault true;
    };
    apps.flatpak.enable = mkDefault true;
    programs.gnome-disks.enable = true;
    # services.ddccontrol.enable = true;
    services.seatd.enable = true;

    environment.systemPackages = with pkgs; [plex-media-player];
  };
}
