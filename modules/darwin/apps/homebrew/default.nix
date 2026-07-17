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
        "Developer" = 640199958;
        "InYourFace" = 1476964367;
        "RDP" = 1295203466;
        "Tailscale" = 1475387142;
        "Telegram" = 747648890;
        "remarkable" = 1276493162;
      };

      taps = [
        {
          name = "osx-cross/arm";
          trusted = true;
          force_auto_update = true;
        }
        {
          name = "osx-cross/avr";
          trusted = true;
          force_auto_update = true;
        }
        {
          name = "qmk/qmk";
          trusted = true;
          force_auto_update = true;
        }
        {
          name = "apple/apple";
          trusted = true;
          force_auto_update = true;
        }
      ];

      brews = [
        # keep-sorted start
        "adwaita-icon-theme"
        "cocoapods"
        "container"
        "container-compose"
        "libadwaita"
        "qmk"
        "soapyhackrf"
        "soapyremote"
        "soapyrtlsdr"
        "soapysdr"
        "swiftformat"
        "swiftlint"
        "swiftly"
        "terminal-notifier"
        "unxip"
        "xcbeautify"
        "xcodes"
        # keep-sorted end
      ];

      casks = [
        # keep-sorted start
        "brave-browser"
        "charles"
        "chiri"
        "devcleaner"
        "elgato-studio"
        "firefox"
        "fldigi"
        "font-adwaita"
        "font-adwaita-mono-nerd-font"
        "ghostty"
        "gitbutler"
        "iterm2@beta"
        "itermai"
        "itermbrowserplugin"
        "jetbrains-toolbox"
        "proxyman"
        "rectangle"
        "screenflow"
        "secretive"
        "slack"
        "swiftbar"
        "termius"
        "ungoogled-chromium"
        # "1password"
        # "cleanshot"
        # "discord"
        # "google-chrome"
        # "hammerspoon"
        # "imageoptim"
        # "istat-menus"
        # "monodraw"
        # "raycast"
        "utm"
        "wezterm"
        "windows-app"
        # keep-sorted end
      ];
    };
  };
}
