{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gui;
in {
  config = lib.mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   # ...

    #   # support both 32- and 64-bit applications
    #   wineWowPackages.stable

    #   # support 32-bit only
    #   wine

    #   # winetricks (all versions)
    #   winetricks

    #   # native wayland support (unstable)
    #   wineWowPackages.waylandFull
    # ];
  };
}
