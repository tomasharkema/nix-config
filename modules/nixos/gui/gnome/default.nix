{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
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
    # services.gnome3.chrome-gnome-shell.enable = true;

    services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.extension-list
      gnomeExtensions.dash-to-panel
      gnomeExtensions.vitals
      gnomeExtensions.appindicator
      gnome.gnome-tweaks
      gnome.gnome-disk-utility
      gnome.gnome-themes-extra
      gnome-firmware
      gjs
      font-manager
      gamehub
      filezilla
      sublime-merge
      remmina
    ];
    programs.hyprland.enable = true;

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
          sansSerif = ["Neue Haas Grotesk Display Pro Bold"];
          serif = ["Neue Haas Grotesk Display Pro Bold"];
        };
        hinting = {
          autohint = true;
          enable = true;
        };
      };
      fonts = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        # noto-fonts-extra
        ubuntu_font_family

        pkgs.custom.neue-haas-grotesk
      ];
    };

    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        gedit # text editor
        epiphany # web browser
        geary # email reader
        gnome-characters
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-contacts
        gnome-initial-setup
      ]);
  };
}
