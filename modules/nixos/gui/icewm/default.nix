{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.icewm;

  preferencesFile = "${./preferences.conf}";
  themeFile = "${./theme.conf}";
in {
  options.gui.icewm = {
    enable = lib.mkEnableOption "icewm";
  };

  config = lib.mkIf cfg.enable {
    gui.fonts.enable = true;

    home.homeFiles = {
      ".icewm/themes" = {
        # enable = true;
        source = "${pkgs.custom.awesome-icewm}/themes";
      };
      ".icewm/preferences" = {source = preferencesFile;};
      ".icewm/theme" = {source = themeFile;};
      # ".config/rofi/config.rasi" = {
      #   # enable = true;
      #   source = "${iceConfig}/rofi/config.rasi";
      # };
    };

    apps.firefox.enable = true;

    services = {
      xserver = {
        enable = true;
        windowManager.icewm.enable = true;
        displayManager.defaultSession = lib.mkDefault "none+icewm";
      };

      xrdp = {
        enable = true;
        defaultWindowManager = "${pkgs.icewm}/bin/icewm";
        # defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
      };
    };

    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [icewm];
      etc = {
        # "icevm-theme" = {
        #   enable = true;
        #   source = "${iceConfig}/icewm";
        #   target = "icewm";
        # };
      };
    };
  };
}
