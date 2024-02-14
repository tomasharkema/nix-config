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
      xrdp.defaultWindowManager = "/run/current-system/sw/bin/gnome-session --session=pantheon";

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
