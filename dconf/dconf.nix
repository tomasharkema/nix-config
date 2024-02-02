# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
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
      palette = ["#45475A" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#BAC2DE" "#585B70" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#A6ADC8"];
      use-theme-colors = false;
      visible-name = "Default";
    };

    "org/gnome/control-center" = {
      last-panel = "background";
      window-state = mkTuple [980 640 false];
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilities" "YaST" "Pardus"];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = ["X-Pardus-Apps"];
      name = "X-Pardus-Apps.directory";
      translate = true;
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = ["gnome-abrt.desktop" "gnome-system-log.desktop" "nm-connection-editor.desktop" "org.gnome.baobab.desktop" "org.gnome.Connections.desktop" "org.gnome.DejaDup.desktop" "org.gnome.Dictionary.desktop" "org.gnome.DiskUtility.desktop" "org.gnome.Evince.desktop" "org.gnome.FileRoller.desktop" "org.gnome.fonts.desktop" "org.gnome.Loupe.desktop" "org.gnome.seahorse.Application.desktop" "org.gnome.tweaks.desktop" "org.gnome.Usage.desktop" "vinagre.desktop"];
      categories = ["X-GNOME-Utilities"];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      # picture-uri = "/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
      # picture-uri-dark = "/run/current-system/sw/share/backgrounds/gnome/adwaita-d.jpg";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "us"])];
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Catppuccin-Mocha-Compact-Blue-Dark";
    };

    "org/gnome/desktop/notifications" = {
      application-children = ["steam" "org-gnome-console" "gnome-power-panel" "firefox"];
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/notifications/application/firefox" = {
      application-id = "firefox.desktop";
    };

    "org/gnome/desktop/notifications/application/gnome-power-panel" = {
      application-id = "gnome-power-panel.desktop";
    };

    "org/gnome/desktop/notifications/application/org-gnome-software" = {
      application-id = "org.gnome.Software.desktop";
    };

    "org/gnome/desktop/peripherals/keyboard" = {
      numlock-state = true;
    };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      lock-enabled = false;
      picture-options = "zoom";
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
      primary-color = "#3071AE";
      secondary-color = "#000000";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/evolution-data-server" = {
      migrated = true;
    };

    "org/gnome/gnome-system-monitor" = {
      maximized = false;
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
      window-state = mkTuple [700 500 102 102];
    };

    "org/gnome/gnome-system-monitor/disktreenew" = {
      col-6-visible = true;
      col-6-width = 0;
    };

    "org/gnome/gnome-system-monitor/proctree" = {
      columns-order = [0 1 2 3 4 6 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26];
      sort-col = 8;
      sort-order = 0;
    };

    "org/gnome/nautilus/preferences" = {
      always-use-location-entry = true;
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/portal/filechooser/com/axosoft/GitKraken" = {
      last-folder-path = "/home/tomas/Developer/nix-config";
    };

    "org/gnome/portal/filechooser/com/sublimemerge/App" = {
      last-folder-path = "/home/tomas/Developer/nix-config";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/shell" = {
      disabled-extensions = ["native-window-placement@gnome-shell-extensions.gcampax.github.com" "workspace-indicator@gnome-shell-extensions.gcampax.github.com"];
      enabled-extensions = ["drive-menu@gnome-shell-extensions.gcampax.github.com" "appindicatorsupport@rgcjonas.gmail.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "dash-to-panel@jderose9.github.com" "Vitals@CoreCoding.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "systemd-manager@hardpixel.eu"];
      favorite-apps = ["org.gnome.Nautilus.desktop" "firefox.desktop" "kitty.desktop" "code.desktop"];
      welcome-dialog-last-shown-version = "45.1";
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      appicon-margin = 8;
      appicon-padding = 4;
      available-monitors = [0];
      dot-position = "BOTTOM";
      hotkeys-overlay-combo = "TEMPORARILY";
      leftbox-padding = -1;
      panel-anchors = ''
        {"0":"MIDDLE"}\n
      '';
      panel-lengths = ''
        {"0":100}\n
      '';
      panel-sizes = ''
        {"0":48}\n
      '';
      primary-monitor = 0;
      status-icon-padding = -1;
      tray-padding = -1;
      window-preview-title-position = "TOP";
    };

    "org/gnome/shell/extensions/systemd-manager" = {
      command-method = "systemctl";
      systemd = [];
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
    };

    "org/gnome/shell/world-clocks" = {
      locations = [];
    };

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
      window-size = mkTuple [857 366];
    };
  };
}
