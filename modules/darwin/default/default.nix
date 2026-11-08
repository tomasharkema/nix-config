{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
# let
#   theme = inputs.themes.custom (inputs.themes.catppuccin-mocha
#     // {
#       base00 = "000000";
#     });
# in
{
  # options = {
  #   variables = lib.mkOption {
  #     type = lib.types.attrs;
  #     default = {
  #       theme = theme;
  #     };
  #   };
  # };
  options = {
    apps._1password.gui.enable = lib.mkEnableOption "1password" // {default = true;};
  };

  config = {
    age = {
      rekey = {
        agePlugins = with pkgs;
          lib.mkForce [
            age-plugin-yubikey
            age-plugin-se
            age-plugin-1p
          ];
      };
      secrets = {
        # atuin = {
        # rekeyFile = ../../nixos/secrets/atuin.age;
        # owner = "${config.user.name}";
        # group = "${config.user.name}";
        # mode = "666";
        # symlink = false;
        # };
        # notify = {
        # rekeyFile = ../../nixos/secrets/notify.age;
        # owner = "${config.user.name}";
        # group = "${config.user.name}";
        # mode = "644";
        # symlink = false;
        # };
      };
    };

    environment = {
      systemPackages =
        (with pkgs.custom; [
          menu
          adsb-tui
        ])
        ++ (with pkgs; [
          # keep-sorted start
          agenix-rekey
          alejandra
          devenv
          direnv
          dosbox-x
          lrzsz
          manix
          # mitmproxy
          nh
          nil
          nix-search-cli
          nixd
          nmap
          # nox
          yubico-piv-tool
          zenmap
          # keep-sorted end
        ]);

      pathsToLink = [
        "/lib"
        "/share/zsh"
        "/share/fonts"
      ];
    };

    system = {
      stateVersion = 4;
      defaults.CustomUserPreferences = {
        "com.apple.desktopservices" = {
          # Avoid creating .DS_Store files on network or USB volumes
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = false;
          ShowMountedServersOnDesktop = false;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          # When performing a search, search the current folder by default
          FXDefaultSearchScope = "SCcf";
          NewWindowTarget = "PfDe";
          # NewWindowTargetPath = "file://$\{HOME\}/Desktop/";
          AppleShowAllExtensions = true;
          FXEnableExtensionChangeWarning = false;
          ShowStatusBar = true;
          ShowPathbar = true;
          WarnOnEmptyTrash = false;
        };
      };
    };

    services = {
      # synergy.server = {
      #   enable = true;
      # };
      tailscale.enable = true;
    };

    fonts = {
      packages = with pkgs; [
        # keep-sorted start
        adwaita-fonts
        b612
        bakoma_ttf
        cm_unicode
        custom.computer-modern
        custom.din
        custom.fast-font
        custom.futura
        exult
        font-awesome
        google-fonts
        inter
        lmmath
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
        nerd-fonts.terminess-ttf
        # noto-fonts
        # noto-fonts-cjk-sans
        # noto-fonts-color-emoji
        pkgs.custom.neue-haas-grotesk
        powerline-fonts
        powerline-symbols
        ubuntu-classic
        vegur
        # helvetica
        virglrenderer
        # keep-sorted end
      ];
    };

    programs = {
      zsh = {
        enable = true;
        # shellInit = ''
        #   export OP_PLUGIN_ALIASES_SOURCED=1
        # '';
      };
      bash.enable = true;
    };

    # programs.fzf.fuzzyCompletion = true;
  };
}
