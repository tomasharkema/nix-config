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
      arduino-ide
      arduino-language-server

      picotool
      cmakeCurses
      gcc-arm-embedded
      gnumake
    ];

    services.udev.packages = with pkgs; [picotool];
  };
}
