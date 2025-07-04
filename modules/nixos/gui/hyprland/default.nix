{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = lib.mkIf config.gui.enable {
    programs = {
      hyprland = {
        enable = true;
        # package = pkgs.hyprland.override {
        #   hidpiXWayland = true;
        # };
      };
      iio-hyprland.enable = true;
      # hyprlock.enable = true;
    };

    security.pam.services.hyprlock = {fprintAuth = true;};

    services = {hypridle.enable = true;};
    environment.systemPackages = with pkgs; [
      hyprpanel
      pyprland
      hyprpicker
      hyprcursor
      hyprshot
      # hyprlock
      # hypridle
      hyprpaper
      hyprutils
      hyprshade
      hyprsysteminfo
      hyprland-autoname-workspaces
      hyprsunset
      hyprland-activewindow

      polybarFull

      # swaynotificationcenter

      cool-retro-term

      hyprpolkitagent
      grim
      slurp
      wl-clipboard
      wlr-randr
    ];

    systemd.packages = with pkgs; [hyprpolkitagent];

    home-manager.users."${config.user.name}" = {
      systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];

      home.sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };

      xdg.portal = {enable = true;};

      programs = {
        rofi = {
          # enable = true;
          package = pkgs.rofi-wayland;
          pass.enable = true;
          terminal = "kitty";
        };

        anyrun = {
          enable = true;
          package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;
          config = {
            plugins = [
              inputs.anyrun.packages.${pkgs.system}.applications
              inputs.anyrun.packages.${pkgs.system}.kidex
              inputs.anyrun.packages.${pkgs.system}.rink
              inputs.anyrun.packages.${pkgs.system}.stdin
              inputs.anyrun.packages.${pkgs.system}.translate
              inputs.anyrun.packages.${pkgs.system}.dictionary
              inputs.anyrun.packages.${pkgs.system}.randr
              inputs.anyrun.packages.${pkgs.system}.shell
              inputs.anyrun.packages.${pkgs.system}.symbols
              inputs.anyrun.packages.${pkgs.system}.websearch
              # An array of all the plugins you want, which either can be paths to the .so files, or their packages
              # inputs.anyrun.packages.${pkgs.system}.applications
            ];
          };
        };

        # wlogout.enable = true;

        hyprlock = {
          enable = true;
        };

        hyprpanel = {
          enable = true;
          systemd.enable = true;
          # hyprland.enable = true;

          settings = {
            theme.font = {
              #   # name = "Inter Variable";
              name = "B612";
              size = "1.0rem";
              weight = 400;
            };
            bar.clock.format = "%d %b %Y   %H:%M:%S";
            menus.clock = {
              weather = {
                location = "Amsterdam";
                unit = "metric";
              };
              time.military = true;
            };

            layout = {
              bar.layouts = {
                "0" = {
                  left = ["dashboard" "workspaces" "windowtitle"];
                  middle = ["media"];
                  right = ["volume" "network" "bluetooth" "battery" "systray" "hypridle" "clock" "notifications"];
                };
              };
            };
          };
        };

        waybar = {
          # enable = true;
          systemd.enable = true;
          style = builtins.readFile ./waybar.css;
          settings = import ./waybar.nix {inherit pkgs;};
        };
      };
      catppuccin = {
        # swaync.font = "B612";
        mako.enable = false;
      };

      services = {
        swaync = {
          enable = false;
        };
        # mako = {
        #   enable = true;
        #   font = "B612 12";
        # };
        # batsignal = {
        #   enable = true;
        #   extraArgs = ["-c 10" "-w 30" "-f disabled" "-D ${pkgs.hyprlock}/bin/hyprlock"];
        # };

        hypridle = {
          enable = true;

          settings = {
            general = {
              ignore_dbus_inhibit = false;
              lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprctl dispatch dpms on";
            };

            listener = [
              {
                timeout = 600;
                on-timeout = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
              }

              {
                timeout = 660;
                on-timeout = "systemctl suspend";
              }
            ];
          };
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          enableXdgAutostart = true;
        };
        xwayland.enable = true;

        extraConfig = builtins.readFile ./hyprland.conf;
        plugins = with pkgs.hyprlandPlugins; [
          # hyprexpo
          # hyprbars
        ];
        settings = {
          "$terminal" = "kitty";
          "$fileManager" = "nautilus";
          "$menu" = "rofi -show drun";

          monitor = ",${
            if config.gui.hidpi.enable
            then "highres"
            else "preferred"
          },auto,${
            if config.gui.hidpi.enable
            then "1.6"
            else "1"
          }";

          env = [
            "HYPRCURSOR_THEME,macOS"
            "HYPRCURSOR_SIZE,24"
            "GDK_SCALE,${
              if config.gui.hidpi.enable
              then "1.6"
              else "1"
            }"
          ];

          exec-once = [
            # "hypridle"
            "systemctl --user start hyprpolkitagent"
            "hyprpanel"
            "[workspace 1 silent] $terminal"
            "${pkgs.networkmanagerapplet}/bin/nm-applet"
            "${pkgs.custom.usbguard-gnome}/bin/usbguard-gnome"

            "[workspace 2 silent] firefox"

            "gsettings set org.gnome.desktop.interface gtk-theme \"catppuccin-mocha-blue-compact+black\"" # for GTK3 apps
            "gsettings set org.gnome.desktop.interface color-scheme \"prefer-dark\"" # for GTK4 apps
            "${lib.getExe pkgs.iio-hyprland}"
          ];

          experimental = {
            # hdr = true;
            # wide_color_gamut = true;
          };
          render = {
            direct_scanout = true;
            # Fixes some apps stuttering (xournalpp, hyprlock). Possibly an amdgpu bug
            explicit_sync = 0;
            explicit_sync_kms = 0;
          };
          windowrulev2 = [
            "float,class:^(firefox)$,title:^(Picture-in-Picture)$"
            "pin,class:^(firefox)$,title:^(Picture-in-Picture)$"
          ];
          general = {allow_tearing = true;};
          xwayland = {force_zero_scaling = true;};

          misc = {vrr = 1;};
        };
      };
    };
  };
}
