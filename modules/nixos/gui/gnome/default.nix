{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.gui.gnome;
in {
  options.gui.gnome = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    services = {
      gnome = {
        gnome-online-accounts.enable = true;
        glib-networking.enable = true;

        gnome-settings-daemon.enable = true;
        gnome-browser-connector.enable = true;
        core-shell.enable = true;
        core-utilities.enable = true;
        chrome-gnome-shell.enable = true;

        gnome-keyring.enable = true;
      };

      udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    };
    xdg.autostart = {
      enable = true;
    };

    services.xserver.libinput.enable = true;

    environment.systemPackages =
      (let
        pkgsUnstable = inputs.unstable.legacyPackages."${pkgs.system}";
      in
        with pkgsUnstable; [
          gnome-extension-manager

          # # pkgs.gnome45Extensions."app-hider@lynith.dev"
          # gnome45Extensions."gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
          # # gnome45Extensions."gsconnect@andyholmes.github.io"
          # gnome45Extensions."gnome-kinit@bonzini.gnu.org"
          # gnome45Extensions."lan-ip-address@mrhuber.com"
          # gnome45Extensions."no-overview@fthx"
          # gnome45Extensions."reboottouefi@ubaygd.com"
          # gnome45Extensions."tailscale@joaophi.github.com"
          # # gnome45Extensions."todo.txt@bart.libert.gmail.com"
          # gnome45Extensions."toggler@hedgie.tech"
          # gnome45Extensions."appindicatorsupport@rgcjonas.gmail.com"
          # # gnome45Extensions."extension-list@tu.berry"
          # # gnome45Extensions."GPU_profile_selector@lorenzo9904.gmail.com"
          # # gnome45Extensions."messagingmenu@lauinger-clan.de"
          # # gnome45Extensions."serverstatus@footeware.ca"
          # # gnome45Extensions."sp-tray@sp-tray.esenliyim.github.com"
          # gnome45Extensions."user-theme@gnome-shell-extensions.gcampax.github.com"
          # gnome45Extensions."Vitals@CoreCoding.com"

          gnome45Extensions."monitor-brightness-volume@ailin.nemui"
          # # gnome45Extensions."systemd-status@ne0sight.github.io"

          # gnomeExtensions.spotify-tray
          gnomeExtensions.arc-menu
          gnomeExtensions.app-hider
          gnomeExtensions.appindicator
          gnomeExtensions.blur-my-shell
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.extension-list
          gnomeExtensions.fuzzy-app-search
          gnomeExtensions.github-actions
          gnomeExtensions.gpu-profile-selector
          gnomeExtensions.hue-lights
          gnomeExtensions.ip-finder
          gnomeExtensions.just-perfection
          gnomeExtensions.kerberos-login
          gnomeExtensions.logo-menu
          gnomeExtensions.no-overview
          gnomeExtensions.remmina-search-provider
          gnomeExtensions.removable-drive-menu
          gnomeExtensions.search-light
          gnomeExtensions.server-status-indicator
          gnomeExtensions.tailscale-qs
          gnomeExtensions.todotxt
          gnomeExtensions.vitals
          gnomeExtensions.removable-drive-menu

          clutter
          clutter-gtk

          gnome.seahorse
          gnome.gnome-tweaks
          gnome.gnome-disk-utility
          gnome.gnome-themes-extra
          gnome-firmware
          gnome-menus
        ])
      ++ (with pkgs; [
        effitask
        clutter
        xdgmenumaker
        gotop
        gtop
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
        libmx
      ]);

    # services.synergy.client = {
    #   enable = true;
    #   serverAddress = "euro-mir";
    # };

    # programs.hyprland = {
    #   enable = true;
    #   enableNvidiaPatches = true;
    # };
    # programs = {
    #   sway.enable = true;
    #   dconf.enable = true;
    # };

    # trace: warning: The option `fonts.fonts' defined in `/nix/store/z1gqs0dm5j9g1qy5j9m7m85al7lhjpim-aca1xyh73qrpxrv4yh6lnavs59q875xf-source/modules/nixos/gui/gnome/default.nix' has been renamed to `fonts.packages'.
    # trace: warning: The option `fonts.enableDefaultFonts' defined in `/nix/store/z1gqs0dm5j9g1qy5j9m7m85al7lhjpim-aca1xyh73qrpxrv4yh6lnavs59q875xf-source/modules/nixos/gui/gnome/default.nix' has been renamed to `fonts.enableDefaultPackages'.

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
        # gnome-characters
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
