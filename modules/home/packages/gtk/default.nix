{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    # services.kbfs = {
    #   enable = true;
    # };

    home.file = let
      autostartPrograms = with pkgs; [_1password-gui telegram-desktop keybase-gui openrgb];
    in
      builtins.listToAttrs (map
        (pkg: {
          name = ".config/autostart/" + pkg.pname + ".desktop";
          value =
            if pkg ? desktopItem
            then {
              # Application has a desktopItem entry.
              # Assume that it was made with makeDesktopEntry, which exposes a
              # text attribute with the contents of the .desktop file
              text = pkg.desktopItem.text;
            }
            else {
              # Application does *not* have a desktopItem entry. Try to find a
              # matching .desktop name in /share/apaplications
              source = pkg + "/share/applications/" + pkg.pname + ".desktop";
            };
        })
        autostartPrograms);

    # services.keybase = {
    #   enable = true;
    #   #   # package = inputs.unstable.legacyPackages."${pkgs.system}".keybase;
    # };
    # home.packages = [pkgs.keybase-gui];
    gtk = {
      enable = true;

      #   gtk3.extraCss = osConfig.variables.theme.adwaitaGtkCss;
      #  gtk4.extraCss = osConfig.variables.theme.adwaitaGtkCss;

      font = {
        #     package = pkgs.custom.b612;
        #   name = "B612 Regular 12";

        # package = pkgs.custom.neue-haas-grotesk;
        # name = "B612 Regular 12";
      };
      theme = lib.mkForce {
        name = "Catppuccin-Mocha-Compact-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "compact";
          tweaks = ["rimless" "black"];
          variant = "mocha";
        };
      };
    };
  };
}
