{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    gtk = {
      enable = true;

      #   gtk3.extraCss = osConfig.variables.theme.adwaitaGtkCss;
      #  gtk4.extraCss = osConfig.variables.theme.adwaitaGtkCss;

      font = {
        package = pkgs.inter;
        name = "Inter Regular 11";

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
