# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  osConfig,
  lib,
  pkgs,
  ...
}:
with lib.hm.gvariant; {
  dconf.settings = lib.mkIf osConfig.services.xserver.desktopManager.gnome.enable {
    # "org/gnome/Console" = { last-window-size = mkTuple [ 652 480 ]; };

    "org/gnome/control-center" = {last-panel = "privacy";};

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = ["X-Pardus-Apps"];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "gnome-abrt.desktop"
        "gnome-system-log.desktop"
        "nm-connection-editor.desktop"
        "org.gnome.baobab.desktop"
        "org.gnome.Connections.desktop"
        "org.gnome.DejaDup.desktop"
        "org.gnome.Dictionary.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.fonts.desktop"
        "org.gnome.Loupe.desktop"
        "org.gnome.seahorse.Application.desktop"
        "org.gnome.tweaks.desktop"
        "org.gnome.Usage.desktop"
        "vinagre.desktop"
      ];
      categories = ["X-GNOME-Utilities"];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    # "org/gnome/desktop/app-folders/folders/YaST" = {
    #   categories = [ "X-SuSE-YaST" ];
    #   name = "suse-yast.directory";
    #   translate = true;
    # };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "us"])];
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};

    "org/gnome/desktop/notifications" = {
      application-children = ["steam" "org-gnome-console" "gnome-power-panel" "firefox"];
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = {numlock-state = true;};

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/screensaver" = {lock-enabled = false;};

    "org/gnome/desktop/session" = {idle-delay = mkUint32 0;};

    "org/gnome/evolution-data-server" = {migrated = true;};

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-panel@jderose9.github.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "firefox.desktop"
        "com.gexperts.Tilix.desktop"
      ];
      welcome-dialog-last-shown-version = "45.1";
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
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
      date-format = "regular";
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
      background-color = "#263238";
      badge-color = "#AC7EA8";
      badge-color-set = false;
      bold-color-set = false;
      cursor-colors-set = false;
      foreground-color = "#A1B0B8";
      highlight-colors-set = false;
      palette = [
        "#252525"
        "#FF5252"
        "#C3D82C"
        "#FFC135"
        "#42A5F5"
        "#D81B60"
        "#00ACC1"
        "#F5F5F5"
        "#708284"
        "#FF5252"
        "#C3D82C"
        "#FFC135"
        "#42A5F5"
        "#D81B60"
        "#00ACC1"
        "#F5F5F5"
      ];
      use-theme-colors = false;
      visible-name = "Default";
    };
  };
}
