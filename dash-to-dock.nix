# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{lib, ...}:
with lib.hm.gvariant; {
  dconf.settings = {
    "org/gnome/shell/extensions/dash-to-dock" = {
      always-center-icons = false;
      apply-custom-theme = false;
      background-opacity = 0.8;
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-fixed = true;
      dock-position = "LEFT";
      extend-height = true;
      height-fraction = 0.9;
      hide-tooltip = false;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      preferred-monitor = -2;
      preferred-monitor-by-connector = "eDP-1";
      preview-size-scale = 0.0;
      show-apps-at-top = true;
      show-mounts-network = true;
      show-trash = false;
    };
  };
}
