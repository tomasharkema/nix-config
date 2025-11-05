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
    programs.niri.enable = true;
    home-manager.users.tomas = {
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
            binds = {
              "Mod+SPACE".action.spawn = "fuzzel";
            };
          };
        };
      };
    };
  };
}
