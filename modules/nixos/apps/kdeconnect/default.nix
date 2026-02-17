{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.gui.gnome.enable {
    programs.kdeconnect = {
      enable = true;
      package = pkgs.kdePackages.kdeconnect-kde;
    };

    environment = {
      etc = {
        "xdg/autostart/org.kde.kdeconnect.daemon.desktop".source = "${pkgs.kdePackages.kdeconnect-kde}/etc/xdg/autostart/org.kde.kdeconnect.daemon.desktop";
      };
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
