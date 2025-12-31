{
  config,
  pkgs,
  lib,
  ...
}: let
  writeINI = p: lib.generators.toINI {} p;
in {
  config = {
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
