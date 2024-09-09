{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gui.fonts = {enable = lib.mkEnableOption "gui.fonts";};

  config = lib.mkIf config.gui.fonts.enable {
    systemd = {
      tmpfiles.rules = [
        "L+ /usr/local/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
      ];
      user.tmpfiles.users.tomas.rules = [
        "L+ /home/tomas/.local/share/fonts - - - - /run/current-system/sw/share/X11/fonts"
      ];
    };

    # system.fsPackages = [pkgs.bindfs];
    # fileSystems = let
    #   mkRoSymBind = path: {
    #     device = path;
    #     fsType = "fuse.bindfs";
    #     options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    #   };
    #   aggregatedIcons = pkgs.buildEnv {
    #     name = "system-icons";
    #     paths = with pkgs; [
    #       #libsForQt5.breeze-qt5  # for plasma
    #       gnome-themes-extra
    #       nixos-icons
    #       adwaita-icon-theme

    #       config.home-manager.users.tomas.gtk.iconTheme.package
    #     ];
    #     pathsToLink = ["/share/icons"];
    #     ignoreCollisions = true;
    #   };
    #   aggregatedFonts = pkgs.buildEnv {
    #     name = "system-fonts";
    #     paths = config.fonts.packages;
    #     pathsToLink = ["/share/fonts"];
    #     ignoreCollisions = true;
    #   };
    # in {
    #   "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    #   "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    # };

    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      fontconfig = {
        enable = true;
        antialias = true;
        # cache32Bit = true;
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
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

      packages = with pkgs; [
        custom.din
        custom.futura
        custom.fast-font
        # exult
        b612
        custom.b612-nerdfont
        bakoma_ttf
        cm_unicode
        dina-font
        fira-code
        fira-code-symbols
        google-fonts
        inter
        liberation_ttf
        lmmath
        mplus-outline-fonts.githubRelease
        nerdfonts
        custom.neue-haas-grotesk
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        open-dyslexic
        open-sans
        proggyfonts
        roboto-mono
        custom.san-francisco
        ubuntu_font_family
        vegur
      ];
    };
  };
}
