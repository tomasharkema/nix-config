{
  lib,
  pkgs,
  ...
}: {
  config = {
    homebrew = {
      enable = true;
      casks = [
        "secretive"
        "1password"
        "cleanshot"
        "discord"
        # "google-chrome"
        "hammerspoon"
        "imageoptim"
        "istat-menus"
        "monodraw"
        "raycast"
        "rectangle"
        "screenflow"
        "slack"
        "spotify"
      ];
    };
  };
}
