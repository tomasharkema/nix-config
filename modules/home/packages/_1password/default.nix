{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}: let
  enableGui =
    pkgs.stdenv.hostPlatform.isDarwin
    || (pkgs.stdenv.hostPlatform.isLinux
      && osConfig.gui.desktop.enable);
in {
  config = lib.mkIf enableGui {
    programs._1password-shell-plugins = {
      enable = true;

      plugins = with pkgs; [
        # gh
        cachix
        hcloud
      ];
    };

    home.packages = lib.mkIf pkgs.stdenv.isLinux [osConfig.programs._1password-gui.package];
  };
}
