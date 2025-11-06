{
  pkgs,
  config,
  lib,
  ...
}: {
  options.gui.fonts = {enable = lib.mkEnableOption "gui.fonts";};

  config = lib.mkIf config.gui.fonts.enable {
    systemd = {
      tmpfiles.settings."10-fonts" = {
        "/usr/local/share/fonts"."L+" = {
          argument = "/run/current-system/sw/share/X11/fonts";
        };
      };
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
          serif = ["Inter Display"];
          sansSerif = ["Inter Display"];
        };
        # hinting = {
        #   autohint = true;
        #   enable = true;
        # };
      };

      packages = with pkgs;
        (builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts))
        ++ [
          # custom.san-francisco
          # exult
          adwaita-fonts
          openmoji-color
          kreative-square
          fairfax-hd
          fairfax
          constructium
          b612
          bakoma_ttf
          cm_unicode
          corefonts
          vista-fonts
          custom.b612-nerdfont
          custom.computer-modern
          custom.din
          custom.fast-font
          custom.futura
          custom.neue-haas-grotesk
          dina-font
          fira-code
          fira-code-symbols
          font-awesome
          google-fonts
          inter
          liberation_ttf
          lmmath
          mplus-outline-fonts.githubRelease
          nerd-fonts.iosevka
          nerd-fonts.jetbrains-mono
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          noto-fonts
          open-dyslexic
          open-sans
          powerline-fonts
          powerline-symbols
          proggyfonts
          roboto-mono
          ubuntu-classic
          vegur
        ];
    };
  };
}
