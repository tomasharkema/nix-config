{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.gui.gnome;
  pkgsUnstable = inputs.unstable.legacyPackages."${pkgs.system}";
in {
  options.gui.gnome = {
    enable = mkEnableOption "enable gnome desktop environment";
  };

  config = mkIf cfg.enable {
    sound.mediaKeys.enable = true;
    traits.developer.enable = mkDefault true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    xdg.portal.wlr.enable = true;
    programs.sway.enable = true;

    # programs.hyprland = {
    #   # Install the packages from nixpkgs
    #   enable = true;
    #   # Whether to enable XWayland
    #   xwayland.enable = true;
    # };
    # environment.etc."X11/Xwrapper.config".text = ''
    #   allowed_users=anybody
    # '';

    services = {
      xrdp.defaultWindowManager = "${pkgs.gnome.gnome-remote-desktop}/bin/gnome-remote-desktop";

      # xrdp.defaultWindowManager = "${pkgs.writeScript "xrdp-xsession-gnome" ''
      #   ${pkgs.gnome.gnome-shell}/bin/gnome-shell &
      #   waitPID=$!
      #   ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
      #   test -n "$waitPID" && wait "$waitPID"
      #   /run/current-system/systemd/bin/systemctl --user stop graphical-session.target
      #   exit 0
      # ''}";

      # xrdp.defaultWindowManager = "${pkgs.gnome.gnome-shell}/bin/gnome-shell";
      # xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session --session=gnomexrdp";

      xserver = {
        desktopManager.gnome.enable = true;

        displayManager = {
          gdm.enable = true;
        };
      };

      gnome = {
        chrome-gnome-shell.enable = true;
        gnome-browser-connector.enable = true;
        gnome-online-accounts.enable = true;
        glib-networking.enable = true;

        gnome-settings-daemon.enable = true;
        core-shell.enable = true;
        core-utilities.enable = true;
        gnome-user-share.enable = true;
        gnome-keyring.enable = true;
        games.enable = true;
        evolution-data-server.enable = true;
      };

      udev.packages = with pkgs; [gnome.gnome-settings-daemon];
      xserver.libinput.enable = true;
    };
    xdg.autostart = {
      enable = true;
    };

    environment.systemPackages =
      (
        with pkgsUnstable; [
          gtop
          libgtop
          gnomeExtensions.dash-to-panel
          gnomeExtensions.executor
          gnomeExtensions.battery-health-charging
          gnomeExtensions.app-menu-icon-remove-symbolic

          gnomeExtensions.window-is-ready-remover

          # gnomeExtensions.network-interfaces-info
          gnomeExtensions.appindicator
          gnomeExtensions.settingscenter
          gnomeExtensions.app-hider
          gnomeExtensions.arc-menu
          gnomeExtensions.blur-my-shell
          gnomeExtensions.clipboard-indicator
          gnomeExtensions.dash-to-dock
          gnomeExtensions.extension-list
          # gnomeExtensions.fuzzy-app-search
          gnomeExtensions.github-actions
          # gnomeExtensions.gpu-profile-selector
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
          gnomeExtensions.tophat
          gnomeExtensions.no-title-bar
          # gnomeExtensions.vitals
          gnomeExtensions.pip-on-top
        ]
      )
      ++ (with pkgsUnstable; [
        clutter
        clutter-gtk
        gjs
        # gnome.adwaita-icon-theme
        gnome-firmware
        gnome-menus
        gnome.dconf-editor
        gnome.gnome-applets
        gnome.gnome-autoar
        gnome.gnome-clocks
        gnome.gnome-control-center
        gnome.gnome-keyring
        gnome.gnome-nettool
        gnome.gnome-online-miners
        gnome.gnome-packagekit
        gnome.gnome-power-manager
        gnome.gnome-session
        gnome.gnome-session-ctl
        gnome.gnome-settings-daemon
        gnome.gnome-shell-extensions
        gnome.gnome-themes-extra
        gnome.gnome-tweaks
        gnome.gnome-user-share
        gnome.libgnome-keyring
        gnome.seahorse
        gnome.zenity
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
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-initial-setup
      ])
      ++ (with pkgsUnstable; [
        # gnome-photos
        gnome-tour
      ])
      ++ (with pkgsUnstable.gnome; [
        cheese # webcam tool
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-initial-setup
      ]);
  };
}
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
# gnome45Extensions."monitor-brightness-volume@ailin.nemui"
# # gnome45Extensions."systemd-status@ne0sight.github.io"
# gnomeExtensions.spotify-tray

