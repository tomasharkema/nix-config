{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.hyprland = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      pyprland
      hyprpicker
      hyprcursor
      hyprlock
      hypridle
      hyprpaper

      hyprsunset

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
      systemd.user.targets.tray.Unit.Requires = lib.mkForce ["graphical-session.target"];
      home.sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };

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
        };

        waybar = {
          enable = true;
          systemd.enable = true;
          style = builtins.readFile ./waybar.css;
          settings = [
            {
              # layer = "top";
              # position = "top";
              height = 50;
              spacing = 10;
              # output = [
              #   "eDP-1"
              #   "HDMI-A-1"
              # ];
              modules-left = [
                "hyprland/workspaces"
                "hyprland/mode"
                "hyprland/scratchpad"
                "wlr/taskbar"
              ];

              modules-center = [
                "hyprland/window"
                #"custom/hello-from-waybar"
              ];
              modules-right = [
                "pulseaudio"

                "mpd"
                "idle_inhibitor"
                "pulseaudio"
                "network"
                "power-profiles-daemon"
                "cpu"
                "memory"
                "temperature"
                "backlight"
                "keyboard-state"
                "sway/language"
                "battery"
                "battery#bat2"
                "backlight"
                "clock"
                "tray"
                "custom/lock"
                "custom/power"
              ];
              "hyprland/workspaces" = {
                disable-scroll = true;
                all-outputs = true;
              };

              "keyboard-state" = {
                "numlock" = true;

                "capslock" = true;
                "format" = "{name} {icon}";
                "format-icons" = {
                  "locked" = "";
                  "unlocked" = "";
                };
              };
              "sway/mode" = {
                "format" = "<span style=\"italic\">{}</span>";
              };
              "sway/scratchpad" = {
                "format" = "{icon} {count}";
                "show-empty" = false;
                "format-icons" = [
                  ""
                  ""
                ];
                "tooltip" = true;
                "tooltip-format" = "{app}: {title}";
              };
              "mpd" = {
                "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
                "format-disconnected" = "Disconnected ";
                "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
                "unknown-tag" = "N/A";
                "interval" = 5;
                "consume-icons" = {
                  "on" = " ";
                };
                "random-icons" = {
                  "off" = "<span color=\"#f53c3c\"></span> ";
                  "on" = " ";
                };
                "repeat-icons" = {
                  "on" = " ";
                };
                "single-icons" = {
                  "on" = "1 ";
                };
                "state-icons" = {
                  "paused" = "";
                  "playing" = "";
                };
                "tooltip-format" = "MPD (connected)";
                "tooltip-format-disconnected" = "MPD (disconnected)";
              };
              "idle_inhibitor" = {
                "format" = "{icon}";
                "format-icons" = {
                  "activated" = "";
                  "deactivated" = "";
                };
              };
              # "tray"= {
              #     // "icon-size"= 21;        "spacing"= 10;
              # };
              # "clock"= {
              #     // "timezone"= "America/New_York";        "tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";        "format-alt"= "{:%Y-%m-%d}"
              # };
              "cpu" = {
                "format" = "{usage}% ";
                "tooltip" = false;
              };
              "memory" = {
                "format" = "{}% ";
              };
              # "temperature"= {
              #     // "thermal-zone"= 2;        // "hwmon-path"= "/sys/class/hwmon/hwmon2/temp1_input";        "critical-threshold"= 80;        // "format-critical"= "{temperatureC}°C {icon}";        "format"= "{temperatureC}°C {icon}";        "format-icons"= ["", "", ""]
              # };
              # "backlight"= {
              #     // "device"= "acpi_video1";        "format"= "{percent}% {icon}";        "format-icons"= ["", "", "", "", "", "", "", "", ""]
              # };
              "battery" = {
                # "states"= {
                #     // "good"= 95;            "warning"= 30;            "critical"= 15
                # };
                "format" = "{capacity}% {icon}";
                "format-full" = "{capacity}% {icon}";
                "format-charging" = "{capacity}% ";
                "format-plugged" = "{capacity}% ";
                "format-alt" = "{time} {icon}"; # // "format-good"= ""; #// An empty format will hide the module
                # // "format-full"= "";        "format-icons"= ["", "", "", "", ""]
              };
              "battery#bat2" = {
                "bat" = "BAT2";
              };
              "power-profiles-daemon" = {
                "format" = "{icon}";
                "tooltip-format" = "Power profile: {profile}\nDriver: {driver}";
                "tooltip" = true;
                "format-icons" = {
                  "default" = "";
                  "performance" = "";
                  "balanced" = "";
                  "power-saver" = "";
                };
              };
              "network" = {
                # // "interface"= "wlp2*", // (Optional) To force the use of this interface
                "format-wifi" = "{essid} ({signalStrength}%) ";
                "format-ethernet" = "{ipaddr}/{cidr} ";
                "tooltip-format" = "{ifname} via {gwaddr} ";
                "format-linked" = "{ifname} (No IP) ";
                "format-disconnected" = "Disconnected ⚠";
                "format-alt" = "{ifname}: {ipaddr}/{cidr}";
              };
              "pulseaudio" = {
                # // "scroll-step"= 1;// %, can be a float
                "format" = "{volume}% {icon} {format_source}";
                "format-bluetooth" = "{volume}% {icon} {format_source}";
                "format-bluetooth-muted" = " {icon} {format_source}";
                "format-muted" = " {format_source}";
                "format-source" = "{volume}% ";
                "format-source-muted" = "";
                "format-icons" = {
                  "headphone" = "";
                  "hands-free" = "";
                  "headset" = "";
                  "phone" = "";
                  "portable" = "";
                  "car" = "";
                  "default" = [
                    ""
                    ""
                    ""
                  ];
                };
                "on-click" = "pavucontrol";
              };
              "custom/media" = {
                "format" = "{icon} {}";
                "return-type" = "json";
                "max-length" = 40;
                "format-icons" = {
                  "spotify" = "";
                  "default" = "🎜";
                };
                "escape" = true;
                "exec" = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null"; # // Script in resources folder
                # // "exec"= "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
              };

              "custom/music" = {
                "format" = " {}";
                "escape" = true;
                "interval" = 5;
                "tooltip" = false;
                "exec" = "playerctl metadata --format='{{ title }}'";
                "on-click" = "playerctl play-pause";
                "max-length" = 50;
              };

              "custom/power" = {
                "format" = "⏻ ";
                "tooltip" = false;
                "menu" = "on-click";
                "menu-file" = "$HOME/.config/waybar/power_menu.xml"; # // Menu file in resources folder
                "menu-actions" = {
                  "shutdown" = "shutdown";
                  "reboot" = "reboot";
                  "suspend" = "systemctl suspend";
                  "hibernate" = "systemctl hibernate";
                };
              };
              "custom/lock" = {
                "tooltip" = false;
                "on-click" = "hyprlock &";
                "format" = "";
              };
              "backlight" = {
                "device" = "nvidia_0";
                "format" = "{icon}";
                "on-scroll-up" = "brightnessctl s '+10%'";
                "on-scroll-down" = "brightnessctl s '10%-'";
                "on-click" = "((( $(brightnessctl g) == 100 )) && brightnessctl s '0') || (brightnessctl s '+10%')";
                "format-icons" = [
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                  ""
                ];
              };
            }
          ];
        };
      };

      services = {
        swaync = {
          enable = true;
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

          render = {
            direct_scanout = true;
            # Fixes some apps stuttering (xournalpp, hyprlock). Possibly an amdgpu bug
            explicit_sync = 0;
            explicit_sync_kms = 0;
          };

          general = {
            allow_tearing = true;
          };
          xwayland = {
            force_zero_scaling = true;
          };
          # exec-once = [ "hyprlock" ];

          misc = {
            vrr = 1;
          };

          plugin = {
            # hyprbars = {
            #   bar_height = 20;
            #   bar_precedence_over_border = true;

            #   # order is right-to-left
            #   hyprbars-button = [
            #     # close
            #     "rgb(ffb4ab), 15, , hyprctl dispatch killactive"
            #     # maximize
            #     "rgb(b6c4ff), 15, , hyprctl dispatch fullscreen 1"
            #   ];
            # };

            # hyprexpo = {
            #   columns = 3;
            #   gap_size = 4;
            #   bg_col = "rgb(000000)";

            #   enable_gesture = true;
            #   gesture_distance = 300;
            #   gesture_positive = false;
            # };
          };

          #   "$mod" = "SUPER";
          #   bind = [
          #     # "$mod, space, exec $menu"
          #   ];
        };
      };
    };
  };
}
