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
