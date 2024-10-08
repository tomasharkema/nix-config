{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.gui.gamemode;
in {
  options.gui.gamemode = {enable = lib.mkEnableOption "gamemode";};

  config = lib.mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   gnomeExtensions.gamemode-indicator-in-system-settings
    # ];
    # home-manager.users.tomas.dconf.settings."org/gnome/shell".enabled-extensions = [pkgs.gnomeExtensions.gamemode-indicator-in-system-settings.extensionUuid];

    programs.gamemode = {
      enable = true;

      enableRenice = false;

      settings = {
        general = {
          softrealtime = "auto";
          # renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations activated'";
          end = "${pkgs.libnotify}/bin/notify-send -a 'Gamemode' 'Optimizations deactivated'";
        };
      };
      # settings = {
      #   general = {
      #     softrealtime = "on";
      #     inhibit_screensaver = 1;
      #   };
      #   gpu = {
      #     apply_gpu_optimisations = "accept-responsibility";
      #     gpu_device = 0;
      #   };
      # };
    };
  };
}
