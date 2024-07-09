{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf config.gui.gnome.enable {
    # programs.kdeconnect = {
    #   enable = true;
    #   package = pkgs.gnomeExtensions.gsconnect;
    # };
  };
}
