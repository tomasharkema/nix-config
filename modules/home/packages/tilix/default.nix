{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.gui.apps.tilix;

  catppuchin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tilix";
    rev = "07e53fce36e2162242c8b70f15996841df8f7ce2";
    hash = "sha256-X8Ks33ELcedyvCA1espbyw4X1gxER6BB8PNxjE6mgk0=";
  };
in {
  options.gui.apps.tilix = {
    # gui.apps.tilix.enable = mkDefault true;
    enable = mkOpt types.bool true "hallo";
  };

  config = mkIf (cfg.enable && pkgs.stdenvNoCC.isLinux && osConfig.gui.enable) {
    xdg.configFile."tilix/schemes" = {
      source = "${catppuchin}/src";
      recursive = true;
    };

    home.packages = with pkgs; [unstable.tilix];
  };
}
