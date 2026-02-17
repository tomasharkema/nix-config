{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.gui.gnome.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.valent;
    };
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };
}
