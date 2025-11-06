{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf pkgs.stdenv.isLinux {
    dconf.settings = {
      "org/gnome/desktop/interface" = {color-scheme = "prefer-dark";};
    };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    };
  };
}
