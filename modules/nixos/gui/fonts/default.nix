{ pkgs, config, lib, ... }:
with lib; {
  options.gui.fonts = { enable = mkEnableOption "gui.fonts"; };

  config = mkIf config.gui.fonts.enable {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      fontconfig = {
        antialias = true;
        cache32Bit = true;
        allowBitmaps = true;

        defaultFonts = {
          monospace = [ "JetBrainsMono Nerd Font Mono" ];
          serif = [ "Inter" ];

          sansSerif = [ "Inter" ];
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
          bakoma_ttf
          lmmath
          exult
          cm_unicode
        ];
    };

    system.fsPackages = [ pkgs.bindfs ];
    fileSystems = let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs;
          [
            apple-cursor
            catppuccin-papirus-folders

            #libsForQt5.breeze-qt5  # for plasma
            gnome.gnome-themes-extra
          ] ++ config.fonts.packages;
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };
  };
}
