{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs = {
      hyprland = {enable = true;};
      hyprlock.enable = true;
    };
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

      grim
      slurp
      wl-clipboard
      wlr-randr
    ];

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

        hyprlock = {enable = true;};

        waybar = {
          enable = true;
          systemd.enable = true;
          style = builtins.readFile ./waybar.css;
          settings = import ./waybar.nix;
        };
      };

      services = {
        swaync = {enable = true;};
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
          monitor = ",preferred,auto,${
            if config.gui.hidpi.enable
            then "1.6"
            else "1"
          }";

          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "GDK_SCALE,${
              if config.gui.hidpi.enable
              then "2"
              else "1"
            }"
          ];

          exec-once = ["hyprshade auto"];
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

          general = {allow_tearing = true;};
          xwayland = {force_zero_scaling = true;};

          misc = {vrr = 1;};
        };
      };
    };
  };
}
