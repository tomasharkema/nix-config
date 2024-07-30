{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.traits.hardware.bluetooth;
in {
  options.traits.hardware.bluetooth = {
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

    services = {
      # blueman.enable = true;
      dbus.enable = true;
      # dconf.enable = true;
    };
    environment.systemPackages = with pkgs; [bluetuith];
  };
}
