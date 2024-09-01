{ pkgs, config, lib, ... }:
let cfg = config.apps.wine;
in with lib; {
  options.apps.wine = { enable = mkEnableOption "steam"; };

  config = lib.mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isx86_64) {
    environment.systemPackages = with pkgs; [
      #   # ...

      #   # support both 32- and 64-bit applications
      wineWowPackages.stable

      #   # support 32-bit only
      wine

      #   # winetricks (all versions)
      winetricks

      #   # native wayland support (unstable)
      #   wineWowPackages.waylandFull
      # bottles
    ];
  };
}
