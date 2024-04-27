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
      extraConfig = ''
        return {
          color_scheme = "Catppuccin Mocha", -- or Macchiato, Frappe, Latte
        }
      '';
    };
  };
}
