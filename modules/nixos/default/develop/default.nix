{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      arduino
      arduino-cli
      arduinoOTA

      arduino-language-server
      (lib.mkIf config.gui.enable arduino-ide)
      picotool
      cmakeCurses
      gcc-arm-embedded
      gnumake
    ];

    services.udev.packages = with pkgs; [picotool];
  };
}
