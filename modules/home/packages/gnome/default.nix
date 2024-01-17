# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with inputs.home-manager.lib.hm.gvariant; {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    dconf.enable = true;

    dconf.settings = {
      "org/gnome/mutter" = {
        edge-tiling = true;
      };

      # "org/gnome/desktop/app-folders" = {
      #   folder-children = ["Utilities" "YaST" "Pardus"];
      # };
      # "org/gnome/desktop/app-folders/folders/Pardus" = {
      #   categories = ["X-Pardus-Apps"];
      #   name = "X-Pardus-Apps.directory";
      #   translate = true;
      # };
      # "org/gnome/desktop/app-folders/folders/Utilities" = {
      #   apps = [
      #     "gnome-abrt.desktop"
      #     "gnome-system-log.desktop"
      #     "nm-connection-editor.desktop"
      #     "org.gnome.baobab.desktop"
      #     "org.gnome.Connections.desktop"
      #     "org.gnome.DejaDup.desktop"
      #     "org.gnome.Dictionary.desktop"
      #     "org.gnome.DiskUtility.desktop"
      #     "org.gnome.Evince.desktop"
      #     "org.gnome.FileRoller.desktop"
      #     "org.gnome.fonts.desktop"
      #     "org.gnome.Loupe.desktop"
      #     "org.gnome.seahorse.Application.desktop"
      #     "org.gnome.tweaks.desktop"
      #     "org.gnome.Usage.desktop"
      #     "vinagre.desktop"
      #   ];
      #   categories = ["X-GNOME-Utilities"];
      #   name = "X-GNOME-Utilities.directory";
      #   translate = true;
      # };
      "org/gnome/shell/extensions/vitals" = {
        "position-in-panel" = 0;
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Catppuccin-Mocha-Compact-Blue-Dark";
        document-font-name = "B612 Regular 11";
        font-antialiasing = "greyscale";
        font-hinting = "full";
        font-name = "B612 Regular 11";
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        always-center-icons = false;
        apply-custom-theme = false;
        background-opacity = 0.8;
        custom-theme-shrink = true;
        dash-max-icon-size = 48;
        dock-fixed = true;
        dock-position = "LEFT";
        extend-height = true;
        height-fraction = 0.9;
        hide-tooltip = false;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        preferred-monitor = -2;
        preferred-monitor-by-connector = "eDP-1";
        preview-size-scale = 0.0;
        show-apps-at-top = true;
        show-mounts-network = true;
        show-trash = false;
      };

      # "org/gnome/desktop/notifications" = {
      #   application-children = ["steam" "org-gnome-console" "gnome-power-panel" "firefox"];
      #   show-in-lock-screen = false;
      # };
      "org/gnome/desktop/peripherals/keyboard" = {numlock-state = true;};
      "org/gnome/desktop/privacy" = {
        old-files-age = mkUint32 30;
        recent-files-max-age = -1;
      };
      "org/gnome/desktop/screensaver" = {lock-enabled = false;};
      # "org/gnome/desktop/session" = {idle-delay = mkUint32 0;};
      "org/gnome/evolution-data-server" = {migrated = true;};
      # "org/gnome/nautilus/preferences" = {
      #   default-folder-viewer = "icon-view";
      #   migrated-gtk-settings = true;
      #   search-filter-time-type = "last_modified";
      # };
      "org/gnome/shell".disable-user-extensions = false;
      "org/gnome/shell".disabled-extensions = [
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      "org/gnome/shell".enabled-extensions = [
        "app-hider@lynith.dev"
        "blur-my-shell@aunetx"
        "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
        "gsconnect@andyholmes.github.io"
        "gnome-kinit@bonzini.gnu.org"
        "lan-ip-address@mrhuber.com"
        "no-overview@fthx"
        "reboottouefi@ubaygd.com"
        # "systemd-manager@hardpixel.eu"
        "tailscale@joaophi.github.com"
        "todo.txt@bart.libert.gmail.com"
        "toggler@hedgie.tech"
        "appindicatorsupport@rgcjonas.gmail.com"
        "extension-list@tu.berry"
        # "github-actions@arononak.github.io"
        "GPU_profile_selector@lorenzo9904.gmail.com"
        "messagingmenu@lauinger-clan.de"
        "remmina-search-provider@alexmurray.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "serverstatus@footeware.ca"
        "sp-tray@sp-tray.esenliyim.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "Vitals@CoreCoding.com"
      ];
      "org/gnome/shell".favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop" "kitty.desktop" "code.desktop"];

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        titlebar-font = "B612 Regular 12";
      };
      "org/gnome/nautilus/preferences" = {always-use-location-entry = true;};
      "org/gnome/shell/extensions/dash-to-panel" = {
        # animate-appicon-hover-animation-extent = {
        #   RIPPLE = 4;
        #   PLANK = 4;
        #   SIMPLE = 1;
        # };
        appicon-margin = 8;
        appicon-padding = 4;
        available-monitors = [0];
        dot-position = "BOTTOM";
        hotkeys-overlay-combo = "TEMPORARILY";
        leftbox-padding = -1;
        panel-anchors = ''
          {"0":"MIDDLE"}
        '';
        panel-lengths = ''
          {"0":100}
        '';
        panel-sizes = ''
          {"0":48}
        '';
        primary-monitor = 0;
        status-icon-padding = -1;
        tray-padding = -1;
        window-preview-title-position = "TOP";
      };
      "org/gnome/shell/world-clocks" = {locations = [];};
      "org/gtk/gtk4/settings/file-chooser" = {
        date-format = "Medium";
        location-mode = "path-bar";
        show-hidden = false;
        show-size-column = true;
        show-type-column = true;
        sidebar-width = 140;
        sort-column = "name";
        sort-directories-first = true;
        sort-order = "ascending";
        type-format = "category";
        view-type = "list";
      };
      "com/gexperts/Tilix" = {
        quake-specific-monitor = 0;
        tab-position = "left";
        theme-variant = "dark";
      };

      "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
        background-color = "#1E1E2E";
        badge-color = "#AC7EA8";
        badge-color-set = false;
        bold-color-set = false;
        cursor-colors-set = false;
        foreground-color = "#A1B0B8";
        highlight-colors-set = false;
        palette = [
          "#45475A"
          "#F38BA8"
          "#A6E3A1"
          "#F9E2AF"
          "#89B4FA"
          "#F5C2E7"
          "#94E2D5"
          "#BAC2DE"
          "#585B70"
          "#F38BA8"
          "#A6E3A1"
          "#F9E2AF"
          "#89B4FA"
          "#F5C2E7"
          "#94E2D5"
          "#A6ADC8"
        ];
        use-theme-colors = false;
        visible-name = "Default";
      };
    };
  };
}
# background-color='#1E1E2E'
# badge-color-set=false
# bold-color-set=false
# cursor-background-color='#F5E0DC'
# cursor-colors-set=true
# cursor-foreground-color='#1E1E2E'
# font='FiraCode Nerd Font weight=450 12'
# foreground-color='#CDD6F4'
# highlight-background-color='#F5E0DC'
# highlight-colors-set=true
# highlight-foreground-color='#1E1E2E'
# palette=['#45475A', '#F38BA8', '#A6E3A1', '#F9E2AF', '#89B4FA', '#F5C2E7', '#94E2D5', '#BAC2DE', '#585B70', '#F38BA8', '#A6E3A1', '#F9E2AF', '#89B4FA', '#F5C2E7', '#94E2D5', '#A6ADC8']
# use-system-font=false
# use-theme-colors=false
# visible-name='Default'

