{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      package = pkgs.wezterm;

      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
