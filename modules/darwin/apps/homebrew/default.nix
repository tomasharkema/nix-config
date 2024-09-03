{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.homebrew;
in {
  options.apps.homebrew = {enable = mkEnableOption "homebrew";};

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      casks = [
        "mas"
        "spotifyd"
        "secretive"
        # "1password"
        "cleanshot"
        "discord"
        "google-chrome"
        "hammerspoon"
        "imageoptim"
        "istat-menus"
        "monodraw"
        # "raycast"
        "rectangle"
        "screenflow"
        "slack"
        "spotify"
        # "kobo"
        "gitbutler"
      ];
    };
  };
}
