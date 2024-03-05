{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.gui;
in {
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
    services.ddccontrol.enable = true;
  };
}
