{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.homebrew;
in {
  options.apps.homebrew = {enable = mkEnableOption "homebrew" // {default = true;};};

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      autoUpdate = true;

      masApps = {
        "termius" = 1176074088;
        "UTM" = 1538878817;
        "Tailscale" = 1475387142;
        "RDP" = 1295203466;
        "slack" = 803453959;
        "Developer" = 640199958;
        "Telegram" = 747648890;
      };
      brews = ["cocoapods" "xcodes"];
      casks = [
        "xcbeautify"
        "xcpretty"
        "swiftbar"
        "swiftlint"
        "swiftformat"
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
