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

        export PATH="/Users/tomas/.local/bin:$PATH"
      '';
    };

    system.primaryUser = "${config.user.name}";

    homebrew = {
      enable = true;
      onActivation.upgrade = true;

      masApps = {
        "UTM" = 1538878817;
        "Tailscale" = 1475387142;
        "RDP" = 1295203466;
        "Developer" = 640199958;
        "Telegram" = 747648890;
        "automute" = 1118136179;
        "remarkable" = 1276493162;
        "InYourFace" = 1476964367;
      };

      brews = [
        "cocoapods"
        "xcodes"
        "xcbeautify"
        # "xcpretty"
        "swiftlint"
        "swiftformat"
        "terminal-notifier"
      ];

      casks = [
        "jetbrains-toolbox"
        "secretive"
        "swiftbar"
        "wezterm"
        "windows-app"
        "ghostty"
        # "docker"
        # "spotifyd"
        # "1password"
        # "cleanshot"
        # "discord"
        # "google-chrome"
        # "hammerspoon"
        # "imageoptim"
        # "istat-menus"
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
