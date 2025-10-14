{
  config,
  lib,
  ...
}: {
  config = {
    home-manager.users."${config.user.name}" = {
      xdg.configFile.hyprpanel = {
        ignorelinks = true;
        recursive = true;
      };
      programs.hyprpanel = {
        enable = true;
        systemd.enable = true;
        # hyprland.enable = true;

        settings = {
          theme.font = {
            name = "Inter Variable";
            # name = "Inter Tight";
            # name = "B612";
            size = "1.0rem";
            weight = 400;
          };

          menus.clock = {
            weather = {
              location = "Amsterdam";
              unit = "metric";
            };
            time.military = true;
          };

          menus.dashboard.directories.enabled = false;
          menus.dashboard.stats.enable_gpu = true;

          theme.bar.transparent = true;

          bar = {
            clock.format = "%a  %d %b %Y  %H:%M:%S";

            launcher.icon = "";
            customModules.ram.labelType = "used/total";
            layouts = {
              "*" = {
                left = [
                  "dashboard"
                  "workspaces"
                  "windowtitle"
                  "cpu"
                  "ram"
                  "cputemp"
                  "netstat"
                ];
                middle = ["media"];
                right = [
                  "volume"
                  "network"
                  "bluetooth"
                  (lib.mkIf config.traits.hardware.laptop.enable "battery")
                  "systray"
                  "hyprsunset"
                  "hypridle"
                  "clock"
                  "notifications"
                  "power"
                ];
              };
            };
          };
        };
      };
    };
  };
}
