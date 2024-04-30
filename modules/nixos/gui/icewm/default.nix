{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gui.icewm;

  preferencesFile = "${./preferences.conf}";
  themeFile = "${./theme.conf}";
in {
  options.gui.icewm = {
    enable = mkEnableOption "icewm";
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
    };

    home.homeFiles = {
      ".icewm/themes/IceAdwaita-Dark-Medium-alpha" = {
        # enable = true;
        source = "${pkgs.custom.awesome-icewm}/themes/IceAdwaita-Dark-Medium-alpha";
      };
      ".icewm/preferences" = {
        source = preferencesFile;
      };
      ".icewm/theme" = {
        source = themeFile;
      };
      # ".config/rofi/config.rasi" = {
      #   # enable = true;
      #   source = "${iceConfig}/rofi/config.rasi";
      # };
    };

    services = {
      xserver = {
        enable = true;
        windowManager.icewm.enable = true;
        displayManager.defaultSession = lib.mkDefault "none+icewm";
      };

      xrdp = {
        enable = true;
        defaultWindowManager = "${pkgs.icewm}/bin/icewm-session";
      };
    };
    environment = {
      systemPackages = [pkgs.icewm];
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
