{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.gui.pantheon;
in {
  options.gui.pantheon = {
    enable = mkEnableOption "enable pantheon desktop environment";
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.pantheon = {
      enable = true;
      debug = true;
    };
    #    programs.pantheon-tweaks.enable = true;
    #   services.pantheon.apps.enable = true;
    #   services.pantheon.contractor.enable = true;
    services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
  };
}
