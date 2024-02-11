{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  enableGui = pkgs.stdenv.isLinux && osConfig.gui.desktop.enable;
in
  with lib; {
    config = mkIf enableGui {
      programs.zsh = {
        initExtraFirst = ''
          export OP_PLUGIN_ALIASES_SOURCED=1
        '';
        shellAliases = {
          gh = "op plugin run -- gh";
          cachix = "op plugin run -- cachix";
        };
      };
      autostart.programs = with pkgs; [_1password-gui];
    };
    # let
    #       autostartPrograms = with pkgs; [
    #         _1password-gui
    #         telegram-desktop
    #         #keybase-gui
    #         openrgb
    #       ];
    #     in
  }
