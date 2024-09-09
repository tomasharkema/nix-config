{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.samsung;
in {
  options.apps.samsung = {
    enable = lib.mkEnableOption "samsung";
  };
  config = lib.mkIf cfg.enable {
    services.udev = {
      enable = true;
      packages = with pkgs; [heimdall-gui libusb];
      extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="685d", MODE="0666"
      '';
    };

    environment.systemPackages = with pkgs; [
      android-tools
      heimdall-gui
    ];
  };
}
