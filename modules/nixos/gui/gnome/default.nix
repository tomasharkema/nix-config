{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.gui.gnome;
in {
  options.gui.gnome = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    services.gnome = {
      gnome-settings-daemon.enable = true;
      gnome-browser-connector.enable = true;
      core-shell.enable = true;
      core-utilities.enable = true;
      chrome-gnome-shell.enable = true;
    };
    services.gnome3.chrome-gnome-shell.enable = true;
    services.gnome = {
      gnome-keyring.enable = true;
    };
    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.extension-list
      gnomeExtensions.dash-to-panel
      gnomeExtensions.dash-to-dock
      gnomeExtensions.vitals

      # gnome-extension-manager

      # gnomeExtensions.git
      # gnomeExtensions.tado
      # gnomeExtensions.ping
      gnomeExtensions.sermon
      gnomeExtensions.todotxt
      gnomeExtensions.rebootto
      gnomeExtensions.ip-finder
      gnomeExtensions.app-hider

      gnomeExtensions.no-overview
      gnomeExtensions.tailscale-qs
      gnomeExtensions.spotify-tray
      # gnomeExtensions.reboottouefi
      # gnomeExtensions.noannoyance-2
      gnomeExtensions.blur-my-shell
      # gnomeExtensions.systemd-status
      # gnomeExtensions.systemd-manager
      gnomeExtensions.messaging-menu
      gnomeExtensions.lan-ip-address
      gnomeExtensions.kerberos-login
      gnomeExtensions.github-actions

      gnomeExtensions.fuzzy-app-search

      gnomeExtensions.removable-drive-menu
      gnomeExtensions.gpu-profile-selector
      gnomeExtensions.server-status-indicator
      gnomeExtensions.remmina-search-provider
      gnomeExtensions.clipboard-indicator

      # logseq

      gnome.seahorse
      gnome.gnome-tweaks
      gnome.gnome-disk-utility
      gnome.gnome-themes-extra
      gnome-firmware
      gnome-menus

      clutter
      xdgmenumaker

      gjs
      font-manager
      gamehub
      filezilla
      sublime-merge
      remmina
      xdg-utils
      mattermost-desktop
      systemdgenie

      # _1password
      wezterm
      waybar
      zeal
    ];

    services.synergy.client = {
      enable = true;
      serverAddress = "0.0.0.0";
    };

    # programs.hyprland = {
    #   enable = true;
    #   enableNvidiaPatches = true;
    # };
    # programs.sway.enable = true;
    programs.dconf.enable = true;

    fonts = {
      enableDefaultFonts = true;
      fontDir.enable = true;
      fontconfig = {
        antialias = true;
        cache32Bit = true;
        # TODO: Set fonts within GNOME Tweaks for the time being
        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font Mono"];
          sansSerif = ["B612 Regular"];
          serif = ["B612 Regular"];
        };
        hinting = {
          autohint = true;
          enable = true;
        };
      };
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk
        nerdfonts
        ubuntu_font_family

        pkgs.custom.neue-haas-grotesk

        # helvetica
        vegur # the official NixOS font
        pkgs.custom.b612
        pkgs.custom.san-francisco
      ];
    };

    environment.gnome.excludePackages =
      (with pkgs; [
        # gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        # gnome-music
        gedit # text editor
        epiphany # web browser
        # geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        # gnome-contacts
        gnome-initial-setup
      ]);
  };
}
