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
        allowBitmaps = true;

        defaultFonts = {
          monospace = ["JetBrainsMono Nerd Font Mono"];
          serif = ["Inter"];

          sansSerif = ["Inter"];
        };
        # hinting = {
        #   autohint = true;
        #   enable = true;
        # };
      };

      packages = with pkgs;
      with pkgs.custom; [
        b612
        inter
        nerdfonts
        neue-haas-grotesk
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        open-dyslexic
        open-sans
        roboto-mono
        san-francisco
        ubuntu_font_family
        vegur
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
