{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (osConfig.gui.desktop.enable && false) {
    home.file = {
      ".wezterm.lua".text = builtins.readFile ./wezterm.lua;
    };
    home.packages = with pkgs; [
      wezterm
    ];
  };
}
