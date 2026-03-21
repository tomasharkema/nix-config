{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    users = {
      users."tomas".extraGroups = ["keyd"];
      groups = {
        "keyd" = {};
      };
    };

    environment = {
      systemPackages = with pkgs; [
        keyd
        qmk
        qmk_hid
        via
      ];
      sessionVariables = {
        QMK_HOME = "/home/tomas/Developer/qmk_firmware";
      };
    };
    # home-manager.users.tomas.dconf = {
    #   settings = {
    #     "org/gnome/mutter" = {
    #       overlay-key = "";
    #     };
    #   };
    # };

    hardware.keyboard.qmk.enable = true;

    systemd.services.keyd.serviceConfig = {
      CapabilityBoundingSet = ["CAP_SETGID"];
    };

    services = {
      libinput.enable = true;
      udev.packages = with pkgs; [
        via
        qmk-udev-rules
      ];
      xserver = {
        # enable = true;

        xkb.layout = "us";
        # xkbVariant = "";
      };

      keyd = {
        enable = true;

        keyboards = {
          # default = {
          #   extraConfig = ''
          #     [main]
          #
          #     # Maps capslock to escape when pressed and control when held.
          #     capslock = overload(control, esc)
          #
          #     # Remaps the escape key to capslock
          #     esc = capslock
          #   '';
          # };

          default = {
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

              # Insertion point movement
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

              # Screenshot
              # [control+shift]
              # 5 = print
            };
          };
        };
      };
    };
  };
}
