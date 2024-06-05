{ pkgs, lib, config, ... }:
with lib;
let cfg = config.gui.gnome;
in {

  options.gui.gnome = {
    extensions = mkOption { type = types.listOf types.package; };

    extensionsUuids = mkOption { type = types.listOf types.str; };
  };

  config = mkIf cfg.enable {

    gui.gnome = {
      extensions = with pkgs; [
        gnomeExtensions.spotify-tray
        gnomeExtensions.dash-to-panel
        gnomeExtensions.executor
        gnomeExtensions.battery-health-charging
        gnomeExtensions.app-menu-icon-remove-symbolic
        gnomeExtensions.pinguxnetlabel
        gnomeExtensions.window-is-ready-remover
        gnomeExtensions.wayland-or-x11
        # gnomeExtensions.network-interfaces-info
        gnomeExtensions.appindicator
        # gnomeExtensions.settingscenter
        gnomeExtensions.app-hider
        gnomeExtensions.arc-menu
        gnomeExtensions.blur-my-shell
        gnomeExtensions.clipboard-indicator
        # gnomeExtensions.dash-to-dock
        gnomeExtensions.extension-list
        # gnomeExtensions.fuzzy-app-search
        gnomeExtensions.github-actions
        # gnomeExtensions.gpu-profile-selector
        gnomeExtensions.hue-lights
        # gnomeExtensions.ip-finder
        gnomeExtensions.just-perfection
        gnomeExtensions.kerberos-login
        # gnomeExtensions.logo-menu
        gnomeExtensions.no-overview
        gnomeExtensions.remmina-search-provider
        gnomeExtensions.removable-drive-menu
        gnomeExtensions.search-light
        gnomeExtensions.server-status-indicator
        gnomeExtensions.tailscale-qs
        gnomeExtensions.todotxt
        # gnomeExtensions.tophat
        # gnomeExtensions.no-title-bar
        # gnomeExtensions.vitals
        gnomeExtensions.pip-on-top
        gnomeExtensions.systemd-manager
        gnomeExtensions.another-window-session-manager

        # gnomeExtensions.custom-command-toggle
        # gnomeExtensions.custom-command-list
        gnomeExtensions.guillotine
        gnomeExtensions.executor
        gnomeExtensions.reboottouefi
      ];

      extensionsUuids = builtins.map (ext: ext.extensionUuid) cfg.extensions;
    };
    environment.systemPackages =
      (with pkgs; [ gnome-extension-manager gnome-extensions-cli ])
      ++ cfg.extensions;

    home-manager.users.tomas.dconf.settings."org/gnome/shell".enabled-extensions =
      cfg.extensionsUuids;

    # enabled-extensions = [
    #   "arcmenu@arcmenu.com"
    #   "gmind@tungstnballon.gitlab.com"
    #   "app-hider@lynith.dev"
    #   "blur-my-shell@aunetx"
    #   # "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
    #   # "gsconnect@andyholmes.github.io"
    #   "gnome-kinit@bonzini.gnu.org"
    #   "lan-ip-address@mrhuber.com"
    #   "no-overview@fthx"
    #   "reboottouefi@ubaygd.com"
    #   # "systemd-manager@hardpixel.eu"
    #   "tailscale@joaophi.github.com"
    #   # "todo.txt@bart.libert.gmail.com"
    #   "toggler@hedgie.tech"
    #   "appindicatorsupport@rgcjonas.gmail.com"
    #   "extension-list@tu.berry"
    #   # "github-actions@arononak.github.io"
    #   # "GPU_profile_selector@lorenzo9904.gmail.com"
    #   # "messagingmenu@lauinger-clan.de"
    #   "remmina-search-provider@alexmurray.github.com"
    #   # "serverstatus@footeware.ca"
    #   # "sp-tray@sp-tray.esenliyim.github.com"
    #   "user-theme@gnome-shell-extensions.gcampax.github.com"
    #   # "dash-to-dock@micxgx.gmail.com"
    #   # "Vitals@CoreCoding.com"
    #   "search-light@icedman.github.com"
    #   "mediacontrols@cliffniff.github.com"
    #   "clipboard-indicator@tudmotu.com"
    #   "monitor-brightness-volume@ailin.nemui"
    #   # "systemd-status@ne0sight.github.io"
    #   "search-light@icedman.github.com"
    #   # "hue-lights@chlumskyvaclav.gmail.com"
    #   # "logomenu@aryan_k"
    #   "just-perfection-desktop@just-perfection"
    #   "todo.txt@bart.libert.gmail.com"
    #   "pip-on-top@rafostar.github.com"
    #   "tailscale-status@maxgallup.github.com"
    #   # "display-brightness-ddcutil@themightydeity.github.com"
    #   "dash-to-panel@jderose9.github.com"
    #   "sermon@rovellipaolo-gmail.com"
    #   # "Airpod-Battery-Monitor@maniacx.github.com"
    #   "extensions-search-provider@G-dH.github.com"
    #   "vscode-search-provider@mrmarble.github.com"
    #   "portforwarding-extension@SJBERTRAND.github.com"
    #   "hass-gshell@geoph9-on-github"
    #   "GPU_profile_selector@lorenzo9904.gmail.com"
    #   "ssh-search-provider@extensions.gnome-shell.fifi.org"
    # ];
  };
}
