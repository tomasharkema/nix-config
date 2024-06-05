{ pkgs, ... }: {
  config = {
    gui.gnome.extensions = [ pkgs.gnomeExtensions.gsconnect ];
    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };
  };
}
