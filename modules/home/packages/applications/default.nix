{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  librepodsDesktopItem = pkgs.makeDesktopItem {
    name = "LibrePods";
    desktopName = "LibrePods";
    exec = "${pkgs.librepods}/bin/librepods --start-minimized";
  };
in {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    dconf.settings."org/gnome/shell".favorite-apps = [
      "org.gnome.Nautilus.desktop"
      "firefox.desktop"
      "org.gnome.Geary.desktop"
      "code.desktop"
      "com.gexperts.Tilix.desktop"
      "kitty.desktop"
      "com.mitchellh.ghostty.desktop"
      "termius-app.desktop"
      # "dev.deedles.Trayscale.desktop"
      "org.telegram.desktop.desktop"
      "1password.desktop"
      "org.cockpit_project.CockpitClient.desktop"
    ];

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = ["org.gnome.Evince.desktop"];
    };

    # autostart.programs = [
    #   {package = pkgs.trayscale;}
    #   # {package = pkgs.zerotier-ui;}

    #   # {package = pkgs.notify-client;}
    #   # {package = pkgs.geary;}
    # ];
    xdg = {
      autostart = {
        enable = true;
        # readOnly = true;
        entries = [
          "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop"
          "${osConfig.programs._1password-gui.package}/share/applications/1password.desktop"
          "${pkgs.solaar}/share/applications/solaar.desktop"
          "${librepodsDesktopItem}/share/applications/LibrePods.desktop"
        ];
      };
    };

    home = {
      packages = with pkgs; [
        telegram-desktop
      ];
      #   file = {
      #     ".config/autostart/org.telegram.desktop.desktop".source = "${pkgs.telegram-desktop}/share/applications/org.telegram.desktop.desktop";
      #     ".config/autostart/org.gnome.usbguard.desktop".source = "${pkgs.custom.usbguard-gnome}/share/applications/org.gnome.usbguard.desktop";
      #     ".config/autostart/1password.desktop".source = "${osConfig.programs._1password-gui.package}/share/applications/1password.desktop";
      #   };
    };
  };
}
