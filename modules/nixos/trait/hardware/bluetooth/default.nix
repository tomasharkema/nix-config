{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.trait.hardware.bluetooth;
in {
  options.trait.hardware.bluetooth = {
    enable = lib.mkEnableOption "ble";

    music.enable = lib.mkEnableOption "music";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        package = pkgs.bluez;
        settings = {General = {MultiProfile = "multiple";};};
        # settings = lib.mkIf cfg.music.enable {General = {Enable = "Source,Sink,Media,Socket";};};
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
