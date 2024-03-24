{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  enableGui = pkgs.stdenv.isLinux && osConfig.gui.desktop.enable && osConfig.gui.gnome.enable;
in
  with lib; {
    config = mkIf enableGui {
      programs.zsh = {
        initExtraFirst = ''
          export OP_PLUGIN_ALIASES_SOURCED=1
        '';
        shellAliases = {
          gh = "op plugin run -- gh";
          # cachix = "op plugin run -- cachix";
        };
      };
      autostart.programs = with pkgs; [_1password-gui];
    };
  }
