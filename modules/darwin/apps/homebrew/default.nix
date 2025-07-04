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

    system.primaryUser = "tomas";

    homebrew = {
      enable = true;
      autoUpdate = true;
      onActivation.upgrade = true;

      masApps = {
        "UTM" = 1538878817;
        "Tailscale" = 1475387142;
        "RDP" = 1295203466;
        # "slack" = 803453959;
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
        "colima"
        "terminal-notifier"
      ];

      casks = [
        "jetbrains-toolbox"
        "chatgpt"
        "secretive"
        "swiftbar"
        "wezterm"
        "windows-app"
        "ghostty"
        "podman-desktop"
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
