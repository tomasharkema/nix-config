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

      # extraConfig = builtins.readFile (pkgs.substituteAll {
      #   src = ./wezterm.lua;

      #   env = {
      #     wezPerProjectWorkspace = "https://github.com/sei40kr/wez-per-project-workspace";
      #     weztermStatus = "https://github.com/yriveiro/wezterm-status";
      #   };
      # });
    };
  };
}
