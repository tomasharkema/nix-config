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
    system.nixos.tags = ["pantheon"];

    programs.pantheon-tweaks.enable = true;
    environment.systemPackages = with pkgs; [pantheon.granite7 pantheon.contractor appeditor monitor];
    services = {
      xrdp.defaultWindowManager = "/etc/X11/Xsession";

      xserver = {
        desktopManager = {
          pantheon = {
            enable = true;
            debug = true;
          };
        };
        displayManager.lightdm = {
          greeters.pantheon.enable = true;
          enable = true;
        };
      };
      pantheon = {
        apps.enable = true;
        contractor.enable = true;
      };
    };
  };
}
