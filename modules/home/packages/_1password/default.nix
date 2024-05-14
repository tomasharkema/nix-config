{ config, osConfig, lib, pkgs, ... }:
let
  enableGui = pkgs.stdenv.isDarwin || (pkgs.stdenv.isLinux
    && osConfig.gui.desktop.enable && osConfig.gui.gnome.enable);
in with lib; {
  config = mkIf enableGui {
    programs.zsh = {
      initExtraFirst = ''
        export OP_PLUGIN_ALIASES_SOURCED=1
      '';
      shellAliases = {
        gh = "op plugin run -- gh";
        # cachix = "op plugin run -- cachix";
        openai = "op plugin run -- openai";
      };
    };
    autostart.programs = with pkgs; mkIf pkgs.stdenv.isLinux [ _1password-gui ];
  };
}
