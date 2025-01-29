{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {};

  config = lib.mkIf pkgs.stdenv.isLinux {
    xdg.configFile."ghostty/config".text = lib.generators.toINIWithGlobalSection {} {
      globalSection = {
        theme = "catppuccin-mocha";
        font-family = "JetBrains Mono";
        background = "000000";
      };
    };

    home.packages = with pkgs; [
      ghostty
    ];
  };
}
