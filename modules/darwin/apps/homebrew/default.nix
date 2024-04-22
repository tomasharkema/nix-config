{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.homebrew;
in {
  options.apps.homebrew = {
    enable = mkBoolOpt true "homebrew";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [
        # "spotifyd"
        "secretive"
        "1password"
        "cleanshot"
        "discord"
        # "google-chrome"
        "hammerspoon"
        "imageoptim"
        "istat-menus"
        "monodraw"
        # "raycast"
        "rectangle"
        "screenflow"
        # "slack"
        "spotify"
        "kobo"
      ];
    };
  };
}
