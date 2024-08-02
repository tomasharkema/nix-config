# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with inputs.home-manager.lib.hm.gvariant;
with lib; {
  config = mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    dconf = {
      settings = {
        "org/gnome/mutter" = {
          edge-tiling = true;
          center-new-windows = true;
          experimental-features = [
            "scale-monitor-framebuffer"
            "variable-refresh-rate"
            "rt-scheduler"
          ];
        };
        "org/gnome/shell/extensions/vitals" = {
          "position-in-panel" = 0;
          show-gpu = true;
          hot-sensors = [
            "_processor_usage_"
            "_memory_usage_"
            "__temperature_avg__"
            "__network-rx_max__"
            "__network-tx_max__"
            "_storage_free_"
            "_gpu#1_utilization_"
          ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          close = "<Super>q";
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          # cursor-theme = mkForce "Adwaita";
          # gtk-theme = "Catppuccin-Mocha-Compact-Blue-Dark";
          document-font-name = "Inter Variable 11";
          font-antialiasing = "grayscale";
          monospace-font-name = "JetBrainsMono Nerd Font Mono 11";
          # font-name = "Inter 11";
          enable-hot-corners = false;
          # icon-theme = "Adwaita";
        };

        "org/gnome/shell/extensions/user-theme" = {
          name = mkDefault "Catppuccin-Mocha-Compact-Blue-Dark";
        };

        # "org/gnome/shell/extensions/TodoTxt" = {
        #   donetxt-location = "/home/tomas/resilio-sync/shared-documents/done.txt";
        #   todotxt-location = "/home/tomas/resilio-sync/shared-documents/todo.txt";
        # };

        "org/gnome/gnome-session" = {
          "auto-save-session" = true;
        };
        "org/gnome/SessionManager" = {
          auto-save-session = true;
        };
        # "/org/gnome/desktop/background" = {
        # "picture-uri" = "/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";

        # "picture-uri-dark" = "/run/current-system/sw/share/backgrounds/gnome/adwaita-l.jpg";
        # };

        # "org/gnome/shell/extensions/dash-to-dock" = {
        #   always-center-icons = false;
        #   apply-custom-theme = false;
        #   background-opacity = 0.8;
        #   custom-theme-shrink = true;
        #   dash-max-icon-size = 48;
        #   dock-fixed = true;
        #   dock-position = "LEFT";
        #   extend-height = true;
        #   height-fraction = 0.9;
        #   hide-tooltip = false;
        #   intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        #   preferred-monitor = -2;
        #   preferred-monitor-by-connector = "eDP-1";
        #   preview-size-scale = 0.0;
        #   show-apps-at-top = true;
        #   show-mounts-network = true;
        #   show-trash = false;
        # };

        "org/gnome/shell/extensions/dash-to-panel" = {
          animate-appicon-hover-animation-extent = builtins.toJSON {
            RIPPLE = 4;
            PLANK = 4;
            SIMPLE = 1;
          };
          appicon-margin = 4;
          appicon-padding = 4;
          appicon-style = "NORMAL";
          available-monitors = "[0]";
          dot-position = "BOTTOM";
          hotkeys-overlay-combo = "TEMPORARILY";
          leftbox-padding = -1;
          panel-anchors = ''{"0":"MIDDLE"}'';
          panel-lengths = ''{"0":100}'';
          panel-sizes = ''{"0":48}'';
          status-icon-padding = -1;
          stockgs-keep-dash = false;
          tray-padding = 5;
          window-preview-title-position = "TOP";
          stockgs-keep-top-panel = true;

          trans-use-custom-opacity = true;
          trans-panel-opacity = 0.4;

          panel-element-positions = builtins.toJSON {
            "0" = [
              {
                element = "showAppsButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "activitiesButton";
                visible = false;
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
                position = "stackedTL";
              }
              {
                element = "centerBox";
                visible = true;
                position = "stackedBR";
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
                "element" = "dateMenu";
                visible = true;
                position = "stackedBR";
              }
              {
                "element" = "desktopButton";
                visible = true;
                position = "stackedBR";
              }
            ];
          };
        };
        # "org/gnome/desktop/notifications" = {
        #   application-children = ["steam" "org-gnome-console" "gnome-power-panel" "firefox"];
        #   show-in-lock-screen = false;
        # };
        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
        };
        # "org/gnome/desktop/screensaver" = {lock-enabled = false;};

        # "org/gnome/shell/extensions/Logo-menu" = {
        #   menu-button-icon-image = 23;
        #   menu-button-icon-size = 20;
        #   menu-button-terminal = "kitty";
        #   show-activities-button = true;
        #   show-power-options = true;
        #   symbolic-icon = true;
        #   use-custom-icon = false;
        # };
        "org/gnome/Console" = {
          custom-font = "JetBrainsMono Nerd Font Mono 11";
        };
        # "org/gnome/shell/extensions/display-brightness-ddcutil" = {
        #   ddcutil-binary-path = "${lib.getExe pkgs.ddcutil}";
        # };

        "org/gnome/shell/extensions/arcmenu" = {
          button-padding = -1;
          custom-menu-button-icon-size = 28.0;
          distro-icon = 22;
          menu-button-appearance = "Icon";
          menu-button-icon = "Distro_Icon";
          menu-font-size = 14;
          menu-layout = "Redmond";
        };

        # [org/gnome/shell/extensions/arcmenu]
        # apps-show-extra-details=true
        # button-padding=-1
        # custom-menu-button-icon-size=28.0
        # distro-icon=22
        # menu-background-color='rgba(48,48,49,0.98)'
        # menu-border-color='rgb(60,60,60)'
        # menu-button-appearance='Icon'
        # menu-button-icon='Distro_Icon'
        # menu-font-size=11
        # menu-foreground-color='rgb(223,223,223)'
        # menu-item-active-bg-color='rgb(25,98,163)'
        # menu-item-active-fg-color='rgb(255,255,255)'
        # menu-item-hover-bg-color='rgb(21,83,158)'
        # menu-item-hover-fg-color='rgb(255,255,255)'
        # menu-layout='Redmond'
        # menu-separator-color='rgba(255,255,255,0.1)'
        # override-menu-theme=false
        # prefs-visible-page=0
        # recently-installed-apps=['io.github.zefr0x.hashes.desktop" "jetbrains-fleet.desktop" "jetbrains-fleet-90197957-61d8-4533-a5f7-c295589d7b0e.desktop" "jetbrains-goland-aa894a40-91d9-41a6-8f8a-a563c92db01f.desktop" "qdirstat.desktop']
        # search-entry-border-radius=(true, 25)
        # show-category-sub-menus=true

        "org/gnome/shell" = {
          disable-user-extensions = false;
          disabled-extensions = [
            "native-window-placement@gnome-shell-extensions.gcampax.github.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          ];
        };
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
          # button-layout = "close,minimize,maximize:";
          titlebar-font = "Inter Regular 11";
        };
        "org/gnome/nautilus/preferences" = {
          always-use-location-entry = true;
        };
        # "org/gnome/shell/extensions/dash-to-panel" = {
        #   # animate-appicon-hover-animation-extent = {
        #   #   RIPPLE = 4;
        #   #   PLANK = 4;
        #   #   SIMPLE = 1;
        #   # };
        #   appicon-margin = 8;
        #   appicon-padding = 4;
        #   available-monitors = [0];
        #   dot-position = "BOTTOM";
        #   hotkeys-overlay-combo = "TEMPORARILY";
        #   leftbox-padding = -1;
        #   panel-anchors = ''
        #     {"0":"MIDDLE"}
        #   '';
        #   panel-lengths = ''
        #     {"0":100}
        #   '';
        #   panel-sizes = ''
        #     {"0":48}
        #   '';
        #   primary-monitor = 0;
        #   status-icon-padding = -1;
        #   tray-padding = -1;
        #   window-preview-title-position = "TOP";
        # };
        # "org/gtk/gtk4/settings/file-chooser" = {
        #   date-format = "Medium";
        #   location-mode = "path-bar";
        #   show-hidden = false;
        #   show-size-column = true;
        #   show-type-column = true;
        #   sidebar-width = 140;
        #   sort-column = "name";
        #   sort-directories-first = true;
        #   sort-order = "ascending";
        #   type-format = "category";
        #   view-type = "list";
        # };

        "com/gexperts/Tilix" = {
          quake-specific-monitor = 0;
          tab-position = "top";
          theme-variant = "dark";
          use-tabs = true;
        };

        "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
          background-color = "#000000";
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
# palette=['#45475A" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#BAC2DE" "#585B70" "#F38BA8" "#A6E3A1" "#F9E2AF" "#89B4FA" "#F5C2E7" "#94E2D5" "#A6ADC8']
# use-system-font=false
# use-theme-colors=false
# visible-name='Default'

