{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.gui.fonts = {enable = mkEnableOption "gui.fonts";};

  imports = [./fontconf.nix];
  disabledModules = ["config/fonts/fontconfig.nix"];

  config = mkIf config.gui.fonts.enable {
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
        din
        futura
        fast-font
        # exult
        b612
        b612-nerdfont
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
        neue-haas-grotesk
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        open-dyslexic
        open-sans
        proggyfonts
        roboto-mono
        san-francisco
        ubuntu_font_family
        vegur
      ];
    };
  };
}
