{pkgs, ...}: let
  lib = pkgs.lib;
  power_menu = pkgs.writeText "power_menu.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
        <object class="GtkMenu" id="menu">
            <child>
                <object class="GtkMenuItem" id="poweroff">
                    <property name="label">Power Off</property>
                </object>
            </child>
            <child>
                <object class="GtkMenuItem" id="reboot">
                    <property name="label">Reboot</property>
                </object>
            </child>
        </object>
    </interface>
  '';
  pingScript = pkgs.writeShellScript "waybar-ping" ''
    ping -q -w 3 -c 1 1.1.1.1 | ${lib.getExe pkgs.jc} --ping | ${lib.getExe pkgs.jq} '.round_trip_ms_avg | round' --unbuffered --compact-output
  '';
in [
  {
    # layer = "top";
    # position = "top";
    height = 30;
    spacing = 2; # 0; # 2; # 10
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
      # "mpd"
      # "idle_inhibitor"
      "network"
      "custom/network"
      "power-profiles-daemon"
      # "cpu"
      # "memory"
      # "temperature"

      # "keyboard-state"
      # "sway/language"
      "battery"

      "backlight"
      "backlight-slider"
      # "pulseaudio"
      "clock"
      "tray"
      "idle_inhibitor"
      "custom/lock"
      "custom/power"
    ];
    "hyprland/workspaces" = {
      disable-scroll = true;
      all-outputs = true;
    };
    clock = {
      interval = 1;
      format = "{:%H:%M:%S}";
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
    "network" = {
      "interface" = "*";
      "format-wifi" = " {bandwidthDowbBits}  {bandwidthUpBits} ";
      "format-ethernet" = " {bandwidthDownBits}  {bandwidthUpBits} ";
      "format-linked" = "(No IP)";
      "format-disconnected" = "";
      "on-click" = "kitty -e nmtui";
      "tooltip" = false;
      "interval" = 5;
    };
    # "sway/scratchpad" = {
    #   "format" = "{icon} {count}";
    #   "show-empty" = false;
    #   "format-icons" = [
    #     ""
    #     ""
    #   ];
    #   "tooltip" = true;
    #   "tooltip-format" = "{app}: {title}";
    # };
    # "mpd" = {
    #   "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
    #   "format-disconnected" = "Disconnected ";
    #   "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
    #   "unknown-tag" = "N/A";
    #   "interval" = 5;
    #   "consume-icons" = {
    #     "on" = " ";
    #   };
    #   "random-icons" = {
    #     "off" = "<span color=\"#f53c3c\"></span> ";
    #     "on" = " ";
    #   };
    #   "repeat-icons" = {
    #     "on" = " ";
    #   };
    #   "single-icons" = {
    #     "on" = "1 ";
    #   };
    #   "state-icons" = {
    #     "paused" = "";
    #     "playing" = "";
    #   };
    #   "tooltip-format" = "MPD (connected)";
    #   "tooltip-format-disconnected" = "MPD (disconnected)";
    # };
    "idle_inhibitor" = {
      "format" = "{icon}";
      "format-icons" = {
        "activated" = "";
        "deactivated" = "";
      };
    };
    "tray" = {
      "icon-size" = 21;
      "spacing" = 10;
    };
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
    "temperature" = {
      "thermal-zone" = 2;
      "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
      "critical-threshold" = 80;
      "format-critical" = "{temperatureC}°C {icon}";
      "format" = "{temperatureC}°C {icon}";
      "format-icons" = ["" "" ""];
    };
    "backlight" = {
      "device" = "acpi_video1";
      "format" = "{percent}% {icon}";
      "format-icons" = ["" "" "" "" "" "" "" "" ""];
    };
    "battery" = {
      "states" = {
        "good" = 95;
        "warning" = 30;
        "critical" = 15;
      };
      "format" = "{capacity}% {icon}";
      "format-full" = "{capacity}% {icon}";
      "format-charging" = "{capacity}% ";
      "format-plugged" = "{capacity}% ";
      "format-alt" = "{time} {icon}"; # // "format-good"= ""; #// An empty format will hide the module
      # // "format-full"= "";
      "format-icons" = ["" "" "" "" ""];
    };
    # "battery#bat2" = {
    # "bat" = "BAT2";
    #  };
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
    # "network" = {
    #   # // "interface"= "wlp2*"; // (Optional) To force the use of this interface
    #   "format-wifi" = "{essid} ";
    #   "format-ethernet" = "{ipaddr}/{cidr} ";
    #   "tooltip-format" = "{ifname} via {gwaddr} ";
    #   "format-linked" = "{ifname} (No IP) ";
    #   "format-disconnected" = "Disconnected ⚠";
    #   "format-alt" = "{ifname}: {ipaddr}/{cidr}";
    # };
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
    "custom/network" = {
      "exec" = pingScript;
      "interval" = 5;
      "format" = "{text} ms";
      "tooltip" = false;
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
      "menu-file" = "${power_menu}"; # // Menu file in resources folder
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
    # "backlight" = {
    #   # "device" = "nvidia_0";
    #   "format" = "{icon}";
    #   "on-scroll-up" = "brightnessctl s '+10%'";
    #   "on-scroll-down" = "brightnessctl s '10%-'";
    #   "on-click" = "((( $(brightnessctl g) == 100 )) && brightnessctl s '0') || (brightnessctl s '+10%')";
    #   "format-icons" = [
    #     ""
    #     ""
    #     ""
    #     ""
    #     ""
    #     ""
    #     ""
    #     ""
    #     ""
    #   ];
    # };
  }
]
