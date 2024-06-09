{ pkgs, lib, config, ... }: {
  config = {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;

      # extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
