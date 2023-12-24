{
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) stdenv;
in {
  homebrew = lib.mkIf stdenv.isDarwin {
    enable = true;
    casks = [
      "1password"
      "cleanshot"
      "discord"
      "google-chrome"
      "hammerspoon"
      "imageoptim"
      "istat-menus"
      "monodraw"
      "raycast"
      "rectangle"
      "screenflow"
      "slack"
      "spotify"
      "fig"
    ];
  };
}
