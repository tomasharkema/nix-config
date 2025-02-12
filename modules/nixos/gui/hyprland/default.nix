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

      dolphin
      swaynotificationcenter

      cool-retro-term

      starship
      helix
      qutebrowser
      zathura
      mpv
      imv
    ];

    home-manager.users.tomas = {
      programs = {
        rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          pass.enable = true;
          terminal = "kitty";
        };
        waybar = {
          enable = true;
          systemd.enable = true;

          settings = [
            {
              mainBar = {
                layer = "top";
                position = "top";
                height = 50;
                # output = [
                #   "eDP-1"
                #   "HDMI-A-1"
                # ];
                modules-left = ["hyprland/workspaces" "hyprland/mode" "wlr/taskbar"];
                modules-center = [
                  "hyprland/window"
                  #"custom/hello-from-waybar"
                ];
                modules-right = [
                  "mpd"
                  # "custom/mymodule#with-css-id"
                  "temperature"
                ];
                "hyprland/workspaces" = {
                  disable-scroll = true;
                  all-outputs = true;
                };
              };
            }
          ];
        };
      };

      services = {
        swaync = {enable = true;};
      };

      wayland.windowManager.hyprland = {
        enable = true;
        systemd = {
          enable = true;
          enableXdgAutostart = true;
        };
        xwayland.enable = true;

        extraConfig = builtins.readFile ./hyprland.conf;

        settings = {
          monitor = ",preferred,auto,${
            if config.gui.hidpi.enable
            then "1.6"
            else "1"
          }";
          #   "$mod" = "SUPER";
          #   bind = [
          #     # "$mod, space, exec $menu"
          #   ];
        };
      };
    };
  };
}
