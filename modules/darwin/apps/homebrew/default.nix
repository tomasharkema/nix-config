{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.homebrew;
in {
  options.apps.homebrew = {enable = lib.mkEnableOption "homebrew" // {default = true;};};

  config = lib.mkIf cfg.enable {
    home-manager.users."${config.user.name}".programs.zsh = {
      initExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };

    homebrew = {
      enable = true;
      autoUpdate = true;
      onActivation.upgrade = true;

      masApps = {
        "termius" = 1176074088;
        "UTM" = 1538878817;
        "Tailscale" = 1475387142;
        "RDP" = 1295203466;
        # "slack" = 803453959;
        "Developer" = 640199958;
        "Telegram" = 747648890;
        "automute" = 1118136179;
        "remarkable" = 1276493162;
      };

      brews = [
        "cocoapods"
        "xcodes"
        "xcbeautify"
        # "xcpretty"
        "swiftlint"
        "swiftformat"
      ];

      casks = [
        "chatgpt"
        "secretive"
        "swiftbar"
        "wezterm"
        "windows-app"
        # "spotifyd"
        # "1password"
        # "cleanshot"
        # "discord"
        # "google-chrome"
        # "hammerspoon"
        # "imageoptim"
        "istat-menus"
        # "monodraw"
        # "raycast"
        "rectangle"
        "screenflow"
        # "slack"
        "spotify"
        # "kobo"
        "gitbutler"
      ];
    };
  };
}
