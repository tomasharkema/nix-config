{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = mkIf config.gui.enable {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      fontconfig = {
        antialias = true;
        cache32Bit = true;

        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font Mono"];
          #   sansSerif = ["B612 Regular"];
          #   serif = ["B612 Regular"];
        };
        hinting = {
          autohint = true;
          enable = true;
        };
      };

      packages = with pkgs; [
        noto-fonts
        noto-fonts-extra
        noto-fonts-emoji
        noto-fonts-cjk
        nerdfonts
        ubuntu_font_family

        pkgs.custom.neue-haas-grotesk

        # helvetica
        vegur # the official NixOS font
        pkgs.custom.b612
        pkgs.custom.san-francisco
        inter
      ];
    };

    system.fsPackages = [pkgs.bindfs];
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          #libsForQt5.breeze-qt5  # for plasma
          gnome.gnome-themes-extra
        ];
        pathsToLink = ["/share/icons"];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = ["/share/fonts"];
      };
    in {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };
  };
}
