{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  options.gui.fonts = {enable = mkEnableOption "gui.fonts";};

  config = mkIf config.gui.fonts.enable {
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
        google-fonts
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
        # exult
        cm_unicode
      ];
    };
  };
}
