{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    # users = {
    #   users."tomas".extraGroups = ["keyd"];
    #   groups = {
    #     "keyd" = {};
    #   };
    # };

    services = {
      libinput.enable = true;

      keyd = {
        enable = true;

        keyboards.mac = {
          extraConfig = ''
            [main]

            # Swap Ctrl and Command keys
            control = layer(meta)
            meta = layer(control)

            # Tab switching
            [meta]
            tab = C-pagedown

            [meta+shift]
            tab = C-pageup

            # Insertion point movement
            [control]
            left = home
            right = end
            up = C-home
            down = C-end

            [alt]
            left = C-left
            right = C-right

            # Screenshot
            [control+shift]
            5 = print
          '';
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
