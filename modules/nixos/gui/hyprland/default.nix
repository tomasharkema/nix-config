{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs = {
      hyprland = {
        enable = true;
        # package = pkgs.hyprland.override {
        #   hidpiXWayland = true;
        # };
      };
      # hyprlock.enable = true;
    };
    security.pam.services.hyprlock = {};

    services = {hypridle.enable = true;};
    environment.systemPackages = with pkgs; [
      iio-hyprland
      wluma
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

      swaynotificationcenter

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
          enable = true;
          package = pkgs.rofi-wayland;
          pass.enable = true;
          terminal = "kitty";
        };

        # wlogout.enable = true;

        hyprlock = {
          # enable = true;
          settings = let
            foreground = "rgba(240, 240, 240, 0.70)";
            font = "B612";
          in {
            general = {
              grace = 5;
              no_fade_in = false;
              disable_loading_bar = false;
            };

            # BACKGROUND
            background = {
              monitor = "";
              blur_passes = 0;
              contrast = 0.8916;
              brightness = 0.7172;
              vibrancy = 0.1696;
              vibrancy_darkness = 0.0;
            };

            label = [
              {
                # Day-Month-Date
                monitor = "";
                text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
                color = foreground;
                font_size = 28;
                font_family = font + " Bold";
                position = "0, 490";
                halign = "center";
                valign = "center";
              }
              # Time
              {
                monitor = "";
                text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
                color = foreground;
                font_size = 160;
                font_family = "steelfish outline regular";
                position = "0, 370";
                halign = "center";
                valign = "center";
              }
              # USER
              {
                monitor = "";
                text = "    $USER";
                color = foreground;
                outline_thickness = 2;
                dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
                dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
                dots_center = true;
                font_size = 18;
                font_family = font + " Bold";
                position = "0, -180";
                halign = "center";
                valign = "center";
              }
            ];

            # INPUT FIELD
            input-field = lib.mkForce {
              monitor = "";
              size = "300, 60";
              outline_thickness = 2;
              dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
              dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
              dots_center = true;
              outer_color = "rgba(25, 25, 25, 0)";
              inner_color = "rgba(25, 25, 25, 0.1)";
              font_color = foreground;
              fade_on_empty = false;
              font_family = font + " Bold";
              placeholder_text = "<i>🔒 Enter Password</i>";
              hide_input = false;
              position = "0, -250";
              halign = "center";
              valign = "center";
            };
          };
        };

        waybar = {
          enable = true;
          systemd.enable = true;
          style = builtins.readFile ./waybar.css;
          settings = import ./waybar.nix {inherit pkgs;};
        };
      };

      services = {
        # swaync = {enable = true;};
        mako = {
          enable = true;

          font = "B612 12";
        };
        batsignal = {
          enable = true;
          extraArgs = ["-c 10" "-w 30" "-f disabled" "-D ${pkgs.hyprlock}/bin/hyprlock"];
        };
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
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "GDK_SCALE,${
              if config.gui.hidpi.enable
              then "1.6"
              else "1"
            }"
          ];

          exec-once = [
            # "hypridle"
            "hyprsunset"
            "systemctl --user start hyprpolkitagent"

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
