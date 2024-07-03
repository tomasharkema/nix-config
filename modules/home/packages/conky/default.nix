{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    services.conky = {
      enable = true;

      extraConfig = builtins.readFile ./conky.lua;
    };
  };
}
