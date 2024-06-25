{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    };

    gtk = mkIf false {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome.gnome-themes-extra;
      };
    };
  };
}
