{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  enableGui =
    pkgs.stdenv.isDarwin
    || (pkgs.stdenv.isLinux
      && osConfig.gui.desktop.enable
      && osConfig.gui.gnome.enable);
in
  with lib; {
    config = mkIf enableGui {
      programs._1password-shell-plugins = {
        # enable 1Password shell plugins for bash, zsh, and fish shell
        enable = true;
        # the specified packages as well as 1Password CLI will be
        # automatically installed and configured to use shell plugins
        plugins = with pkgs; [gh cachix openai hcloud awscli2];
      };

      home.packages = mkIf pkgs.stdenv.isLinux [osConfig.programs._1password-gui.package];
    };
  }
