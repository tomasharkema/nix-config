{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    };

    gtk = lib.mkIf false {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };
  };
}
