{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.gui.gnome.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
