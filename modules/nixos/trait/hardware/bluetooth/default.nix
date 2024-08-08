{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.trait.hardware.bluetooth;
in {
  options.trait.hardware.bluetooth = {
    enable = mkEnableOption "ble";

    music.enable = mkEnableOption "music";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = mkIf cfg.music.enable {General = {Enable = "Source,Sink,Media,Socket";};};
      };
    };

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      {package = airpod-battery-monitor;}
    ];

    services = {
      blueman.enable = true;
      dbus.enable = true;
      # dconf.enable = true;
    };
    environment.systemPackages = with pkgs; [
      bluetuith
      blueberry
      btlejack
      ultrablue-server
    ];
  };
}
