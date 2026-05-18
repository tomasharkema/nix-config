{
  config,
  pkgs,
  lib,
  ...
}: let
  writeINI = p: lib.generators.toINI {} p;
in {
  config = {
    home.packages = with pkgs; [
      qmk
    ];

    xdg.configFile = {
      "qmk/qmk.ini".text = writeINI {
        user = {
          keyboard = "adafruit/macropad";
          keymap = "vial";
        };
      };
    };
  };
}
