{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}: let
  bgGenerate = name: srcc:
    pkgs.stdenv.mkDerivation {
      name = "png-${name}.png";

      phases = ["buildPhase"];
      buildInputs = with pkgs; [imagemagick];

      buildPhase = ''
        touch $out
        convert -density 1536 -background none -size 3840x2160 ${srcc} $out
      '';
    };

  isSvg = false;

  __bg = pkgs.fetchurl {
    url = "https://i.redd.it/52bb00rh254d1.jpeg";
    sha256 = "sha256-HxfX3ekUuZLluyN1yvfqVIQaNSejhV03sGFzi22zZ24=";
  };

  _bg = pkgs.fetchurl {
    url = "https://i.redd.it/4yglzy4rkh4d1.jpeg";
    sha256 = "sha256-HxfX3ekUuZLluyN1yvfqVIQaNSejhV03sGFzi22zZ24=";
  };

  bg2 = pkgs.fetchurl {
    url = "https://i.redd.it/52bb00rh254d1.jpeg";
    sha256 = "sha256-2BQKeHFUPXk6YzF8XzIuvYestvBp27/WZqvZqAdZewE=";
  };

  bg = pkgs.fetchurl {
    url = "https://4kwallpapers.com/images/wallpapers/astrophotography-5120x2880-21270.jpg";
    sha256 = "0ir1rs0dfqjcj55i09d5kjxz0s50kcb08fmlm46w16bkpmzqzxns";
  };

  bgLight = bg;
  bgPng = bgGenerate "bg" bg;
  bgLightPng = bgGenerate "bgLight" bgLight;
in {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    gtk.gtk3.bookmarks = [
      "file:///home/tomas/Downloads"
      "file:///home/tomas/Dropbox"
      "file:///home/tomas/Developer"
      "file:///home/tomas/Developer/nix-config"
      "file:///mnt/steam"
      "file:///mnt/resilio-sync"
      "file:///mnt/servers"
      "file:///run/user/1000/kbfs"
    ];

    services = {
      trayscale = {
        enable = true;
        hideWindow = true;
      };
      # yubikey-agent.enable = true;
      gnome-keyring = {
        components = ["pkcs11" "secrets"];
        enable = true;
      };
      activitywatch.enable = true;
      tldr-update.enable = true;
    };

    xsession.enable = true;

    xdg = {
      userDirs = {
        enable = true;
        createDirectories = true;
        extraConfig = {
          XDG_DEV_DIR = "${config.home.homeDirectory}/Developer";
        };
      };
      desktopEntries = {
        avahi-discover = {
          name = "Avahi Discover";
          genericName = "Avahi Discover";
          exec = "${osConfig.services.avahi.package}/bin/avahi-discover-standalone";
          terminal = false;
          categories = [
            "Application"
            "Network"
            "WebBrowser"
          ];
          icon = "network-wired";
        };
      };
    };
    dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri = "file://${bg}";
        picture-uri-dark = "file://${bg}";
      };
    };
    services.poweralertd.enable = true;
    home = {
      packages = with pkgs; [
        # custom.zerotier-ui
        notify-client
        trayscale
      ];

      activation = {
        # userSymlinks-cachix = ''
        #   if [ ! -d "$HOME/.config/cachix" ]; then
        #     mkdir $HOME/.config/cachix
        #   fi
        #   ln -sfn /etc/cachix.dhall $HOME/.config/cachix/cachix.dhall
        # '';

        userSymlinks-notify = ''
          if [ ! -d "$HOME/.config/notify" ]; then
            mkdir $HOME/.config/notify
            chown tomas:tomas -R /home/tomas/.config
          fi
          ln -sfn "${osConfig.age.secrets.notify.path}" ~/.config/notify/provider-config.yaml
        '';
      };

      file = {
        # ".face" = {
        #   source = pkgs.fetchurl {
        #     url = "https://avatars.githubusercontent.com/u/4534203?t=1";
        #     sha256 = "sha256:1g4mrz2d8h13rp8z2b9cn1wdr4la5zzrfkqgblayb56zg7706ga6";
        #   };
        # };
        ".background-image.svg" = lib.mkIf isSvg {source = "${bg}";};
        ".background-image.jpg" = lib.mkIf (!isSvg) {source = "${bg}";};
        ".background-image".source = "${bg}";
        ".background-image.png".source = "${bgPng}";
        ".background-image-light.png".source = "${bgLightPng}";
        # "wp.jpg" = {
        #   source = builtins.fetchurl {
        #     url = "https://t.ly/n3kq7";
        #     sha256 = "sha256:0p9lyarqw63b1npicc5ps8h6c34n1137f7i6qz3jrcxg550girh0";
        #   };
        # };
        # "wp.png" = {
        #   source = builtins.fetchurl {
        #     url = "https://t.ly/r76YX";
        #     sha256 = "sha256:0g4a6a5yy4mdlqkvw3lc02wgp4hmlvj0nc8lvlgigkra95jq9x3x";
        #   };
        # };
        # ".config/cachix/cachix.dhall".source = config.lib.file.mkOutOfStoreSymlink "/etc/cachix.dhall"; # osConfig.age.secrets.cachix.path;
        # ".config/notify/provider-config.yaml".source = osConfig.age.secrets.notify.path;
        # "${config.xdg.dataHome}/Zeal/Zeal/docsets/nixpkgs.docset" = {
        #   # /nixpkgs.docset" = {
        #   source = config.lib.file.mkOutOfStoreSymlink "${pkgs.custom.nixpkgs-docset}/nixpkgs.docset";
        #   recursive = true;
        # };
        ".local/share/flatpak/overrides/global" = {
          text = ''
            [Context]
            filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro;~/.local/share/fonts:ro;~/.icons:ro;
          '';
        };
        # /home/tomas/.config/gtk-4.0:ro;/home/tomas/.config/gtk-3.0:ro;
        # };
        # ".local/share/Zeal/Zeal/docsets/nixos.docset" = {
        # source = "${pkgs.docset}/share/docset-24.05.docset";
        # };
      };
    };
  };
}
