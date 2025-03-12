{
  config,
  pkgs,
  lib,
  ...
}: let
  hyprlock-blur = pkgs.writeShellScriptBin "hyprlock-blur" ''
    ${pkgs.grim}/bin/grim -o DP-2 -l 0 /tmp/screenshot1.png &
    ${pkgs.grim}/bin/grim -o HDMI-A-1 -l 0 /tmp/screenshot2.png &
    wait &&
    hyprlock
  '';
in {
  config = {
    programs = {
      hyprland = {
        enable = true;
        # package = pkgs.hyprland.override {
        #   hidpiXWayland = true;
        # };
      };
      hyprlock.enable = true;
    };
    security.pam.services.hyprlock = {};

    services = {hypridle.enable = true;};
    environment.systemPackages = with pkgs; [
      pyprland
      hyprpicker
      hyprcursor
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

      starship
      helix
      qutebrowser
      zathura
      mpv
      imv

      hyprpolkitagent
      grim
      slurp
      wl-clipboard
      wlr-randr
    ];
    systemd.packages = with pkgs; [hyprpolkitagent];
    home-manager.users.tomas = {
      systemd.user.targets.tray.Unit.Requires =
        lib.mkForce ["graphical-session.target"];
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

        wlogout.enable = true;

        hyprlock = {
          enable = true;
          settings = {
            input-field = {
              monitor = "DP-3";
              size = "200,50";
              outline_thickness = 2;
              dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
              dots_spacing = 0.35; # Scale of dots' absolute size, 0.0 - 1.0
              dots_center = true;
              outer_color = "rgba(0, 0, 0, 0)";
              inner_color = "rgba(0, 0, 0, 0.2)";
              font_color = "rgb(111, 45, 104)";
              fade_on_empty = false;
              rounding = -1;
              check_color = "rgb(30, 107, 204)";
              placeholder_text = ''<i><span foreground="##cdd6f4">Input Password...</span></i>'';
              hide_input = false;
              position = "0, -100";
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
        hypridle = {
          enable = true;
          settings = {
            general = {
              # lock_cmd = ''${pkgs.libnotify}/bin/notify-send "lock!"''; # dbus/sysd lock command (loginctl lock-session)
              # unlock_cmd = ''${pkgs.libnotify}/bin/notify-send "unlock!"''; # same as above, but unlock
              # before_sleep_cmd = ''${pkgs.libnotify}/bin/notify-send "Zzz"''; # command ran before sleep
              # after_sleep_cmd = ''${pkgs.libnotify}/bin/notify-send "Awake!"''; # command ran after sleep
              ignore_dbus_inhibit =
                false; # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
              ignore_systemd_inhibit =
                false; # whether to ignore systemd-inhibit --what=idle inhibitors
            };

            listener = {
              timeout = 500; # in seconds
              # on-timeout = ''${pkgs.libnotify}/bin/notify-send "You are idle!"''; # command to run when timeout has passed
              # on-resume = ''${pkgs.libnotify}/bin/notify-send "Welcome back!"''; # command to run when activity is detected after timeout has fired.
            };
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
            "hyprshade auto"
            "hypridle"
            "hyprsunset"
            "systemctl --user start hyprpolkitagent"

            "[workspace 1 silent] $terminal"
            "nm-applet & usbguard-gnome &"

            "[workspace 2 silent] firefox"
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
