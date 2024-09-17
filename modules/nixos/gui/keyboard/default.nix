{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf (cfg.enable) {
    #  users = {
    #   users."tomas".extraGroups = ["keyd"];
    #   groups = {
    #     "keyd" = {};
    #   };
    # };
    environment.systemPackages = with pkgs; [keyd];

    # home-manager.users.tomas.dconf = {
    #   settings = {
    #     "org/gnome/mutter" = {
    #       overlay-key = "";
    #     };
    #   };
    # };

    services = {
      libinput.enable = true;

      xserver = {
        enable = true;

        layout = "us";
        # xkbVariant = "";
      };

      keyd = {
        # enable = true;

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

          # mac = {
          default = {
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
      };
    };
  };
}
