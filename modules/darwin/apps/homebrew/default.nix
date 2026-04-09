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
    # home-manager.users."${config.user.name}".programs.zsh = {
    #   initContent = ''
    #     eval "$(/opt/homebrew/bin/brew shellenv)"

    #     export PATH="/Users/tomas/.local/bin:$PATH"
    #   '';
    # };

    system.primaryUser = "${config.user.name}";

    homebrew = {
      enable = true;
      onActivation.upgrade = true;
      enableZshIntegration = true;

      masApps = {
        # keep-sorted start
        "Developer" = 640199958;
        "InYourFace" = 1476964367;
        "RDP" = 1295203466;
        "Tailscale" = 1475387142;
        "Telegram" = 747648890;
        "UTM" = 1538878817;
        "automute" = 1118136179;
        "remarkable" = 1276493162;
        # keep-sorted end
      };

      brews = [
        # keep-sorted start
        "adwaita-icon-theme"
        "cocoapods"
        "container"
        "container-compose"
        "libadwaita"
        "swiftformat"
        # "xcpretty"
        "swiftlint"
        "swiftly"
        "terminal-notifier"
        "xcbeautify"
        "xcodes"
        # keep-sorted end
      ];

      casks = [
        # keep-sorted start
        "font-adwaita"
        "font-adwaita-mono-nerd-font"
        "ghostty"
        # "kobo"
        "gitbutler"
        "jetbrains-toolbox"
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
        "secretive"
        # "slack"
        "spotify"
        "swiftbar"
        "ungoogled-chromium"
        "wezterm"
        "windows-app"
        # keep-sorted end
      ];
    };
  };
}
