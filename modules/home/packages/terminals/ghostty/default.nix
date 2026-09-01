{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {};

  config = {
    xdg.configFile = {
      "ghostty/config".text = lib.generators.toINIWithGlobalSection {} {
        globalSection = {
          theme = "catppuccin-mocha";
          font-family = "JetBrainsMono Nerd Font Mono";
          background = "000000";
        };
      };
      "ghostty/themes/catppuccin-mocha".text = lib.mkIf pkgs.hostPlatform.isDarwin ''
        palette = 0=#45475a
        palette = 1=#f38ba8
        palette = 2=#a6e3a1
        palette = 3=#f9e2af
        palette = 4=#89b4fa
        palette = 5=#f5c2e7
        palette = 6=#94e2d5
        palette = 7=#a6adc8
        palette = 8=#585b70
        palette = 9=#f38ba8
        palette = 10=#a6e3a1
        palette = 11=#f9e2af
        palette = 12=#89b4fa
        palette = 13=#f5c2e7
        palette = 14=#94e2d5
        palette = 15=#bac2de
        background = 1e1e2e
        foreground = cdd6f4
        cursor-color = f5e0dc
        cursor-text = 11111b
        selection-background = 353749
        selection-foreground = cdd6f4
        split-divider-color = 313244
      '';
    };

    programs.ghostty = lib.mkIf pkgs.hostPlatform.isLinux {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
