# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    # "org/gnome/Console" = { last-window-size = mkTuple [ 652 480 ]; };

    "org/gnome/control-center" = { last-panel = "privacy"; };

    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" "YaST" "Pardus" ];
    };

    "org/gnome/desktop/app-folders/folders/Pardus" = {
      categories = [ "X-Pardus-Apps" ];
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
      categories = [ "X-GNOME-Utilities" ];
      name = "X-GNOME-Utilities.directory";
      translate = true;
    };

    # "org/gnome/desktop/app-folders/folders/YaST" = {
    #   categories = [ "X-SuSE-YaST" ];
    #   name = "suse-yast.directory";
    #   translate = true;
    # };

    "org/gnome/desktop/input-sources" = {
      sources = [ (mkTuple [ "xkb" "us" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };

    "org/gnome/desktop/notifications" = {
      application-children =
        [ "steam" "org-gnome-console" "gnome-power-panel" "firefox" ];
      show-in-lock-screen = false;
    };

    "org/gnome/desktop/peripherals/keyboard" = { numlock-state = true; };

    "org/gnome/desktop/privacy" = {
      old-files-age = mkUint32 30;
      recent-files-max-age = -1;
    };

    "org/gnome/desktop/screensaver" = { lock-enabled = false; };

    "org/gnome/desktop/session" = { idle-delay = mkUint32 0; };

    "org/gnome/evolution-data-server" = { migrated = true; };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "gsconnect@andyholmes.github.io"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "apps-menu@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "dash-to-panel@jderose9.github.com"
        "Vitals@CoreCoding.com"
      ];
      favorite-apps = [ "firefox.desktop" ];
      welcome-dialog-last-shown-version = "45.1";
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      # Even when we are not using multiple panels on multiple monitors,
      # the extension still creates them in the config, so we set the same
      # configuration for each (up to 2 monitors).
      panel-positions = builtins.toJSON (lib.genAttrs [ "0" "1" ] (x: "TOP"));
      panel-sizes = builtins.toJSON (lib.genAttrs [ "0" "1" ] (x: 32));
      panel-element-positions = builtins.toJSON (lib.genAttrs [ "0" "1" ] (x: [
        {
          element = "showAppsButton";
          visible = true;
          position = "stackedTL";
        }
        {
          element = "activitiesButton";
          visible = false;
          position = "stackedTL";
        }
        {
          element = "dateMenu";
          visible = true;
          position = "stackedTL";
        }
        {
          element = "leftBox";
          visible = true;
          position = "stackedTL";
        }
        {
          element = "taskbar";
          visible = true;
          position = "centerMonitor";
        }
        {
          element = "centerBox";
          visible = false;
          position = "centered";
        }
        {
          element = "rightBox";
          visible = true;
          position = "stackedBR";
        }
        {
          element = "systemMenu";
          visible = true;
          position = "stackedBR";
        }
        {
          element = "desktopButton";
          visible = false;
          position = "stackedBR";
        }
      ]));
      multi-monitors = false;
      show-apps-icon-file =
        "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
      show-apps-icon-padding = mkInt32 4;
      focus-highlight-dominant = true;
      dot-size = mkInt32 0;
      appicon-padding = mkInt32 2;
      appicon-margin = mkInt32 0;
      trans-use-custom-opacity = true;
      trans-panel-opacity = 0.25;
      show-favorites = false;
      group-apps = false;
      isolate-workspaces = true;
      hide-overview-on-startup = true;
      stockgs-keep-dash = true;
    };

    "org/gnome/shell/world-clocks" = { locations = [ ]; };

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
  };
}
