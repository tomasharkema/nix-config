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

      dolphin
      rofi-wayland
      swaynotificationcenter

      cool-retro-term

      starship
      helix
      waybar
      qutebrowser
      zathura
      mpv
      imv
    ];

    home-manager.users.tomas = {
      programs = {
        rofi = {
          enable = true;
          pass.enable = true;
          terminal = "kitty";
        };
        waybar = {
          enable = true;
          systemd.enable = true;
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

        # settings = {
        #   "$mod" = "SUPER";
        #   bind = [
        #     # "$mod, space, exec $menu"
        #   ];
        # };
      };
    };
  };
}
