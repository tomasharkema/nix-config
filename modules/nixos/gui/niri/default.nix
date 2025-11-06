{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfgDesktop = config.gui.desktop;
in {
  config = lib.mkIf cfgDesktop.enable {
    programs = {
      niri.enable = true;
    };

    security.pam.services.swaylock = {};

    home-manager.users.tomas = {
      services = {
        swayidle = let
          # Lock command
          lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
          # TODO: modify "display" function based on your window manager
          # Sway
          # display = status: "swaymsg 'output * power ${status}'"; \
          # Hyprland
          # display = status: "hyprctl dispatch dpms ${status}";
          # Niri
          display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
        in {
          enable = true;
          timeouts = [
            {
              timeout = 15; # in seconds
              command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
            }
            {
              timeout = 20;
              command = lock;
            }
            {
              timeout = 25;
              command = display "off";
              resumeCommand = display "on";
            }
            {
              timeout = 30;
              command = "${pkgs.systemd}/bin/systemctl suspend";
            }
          ];
          events = [
            {
              event = "before-sleep";
              # adding duplicated entries for the same event may not work
              command = (display "off") + "; " + lock;
            }
            {
              event = "after-resume";
              command = display "on";
            }
            {
              event = "lock";
              command = (display "off") + "; " + lock;
            }
            {
              event = "unlock";
              command = display "on";
            }
          ];
        };

        mako.enable = true;
      };

      programs = {
        fuzzel.enable = true;
        alacritty.enable = true;

        niri = {
          settings = {
            spawn-at-startup = [
              {argv = ["waybar"];}
              {argv = ["firefox"];}
              {argv = ["1password"];}
              # {argv = ["swaybg" "--image" "/path/to/wallpaper.jpg"];}
              # {argv = ["~/.config/niri/scripts/startup.sh"];}
            ];
            # binds = {
            #   "Mod+SPACE".action.spawn = "fuzzel";
            # };
          };
        };
      };
    };
  };
}
