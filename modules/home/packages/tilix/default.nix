{ config, osConfig, pkgs, lib, ... }:
with lib;
with lib.custom;
let
  cfg = config.gui.apps.tilix;

  catppuchin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tilix";
    rev = "3fd05e03419321f2f2a6aad6da733b28be1765ef";
    hash = "sha256-SI7QxQ+WBHzeuXbTye+s8pi4tDVZOV4Aa33mRYO276k=";
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

    home.packages = with pkgs; [ tilix ];
  };
}
