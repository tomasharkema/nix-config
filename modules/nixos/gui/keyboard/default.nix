{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    users = {
      users."tomas".extraGroups = ["keyd"];
      groups = {
        "keyd" = {};
      };
    };

    services = {
      libinput.enable = true;

      keyd = {
        enable = true;

        keyboards.mac = {
          settings = {
            main = {
              control = "layer(meta)";
              meta = "layer(control)";
            };
            meta = {
              tab = "C-pagedown";
            };
            "meta+shift" = {
              tab = "C-pageup";
            };
            control = {
              left = "home";
              right = "end";
              up = "C-home";
              down = "C-end";
            };
            alt = {
              left = "C-left";
              right = "C-right";
            };
            "control+shift" = {
              "5" = "print";
            };
          };
        };
      };

      xserver = {
        enable = true;

        layout = "us";
        # xkbVariant = "";
      };
    };
  };
}
