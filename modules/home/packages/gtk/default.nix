{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  catppuccin_name = "Catppuccin-Mocha-Compact-Blue-Dark";
  catppuccin = pkgs.catppuccin-gtk.override {
    accents = ["blue"];
    size = "compact";
    tweaks = ["rimless" "black"];
    variant = "mocha";
  };
in {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
    gtk = {
      enable = true;

      font = {
        package = pkgs.inter;
        name = "Inter Regular";
        size = 11;
      };

      theme = lib.mkForce {
        name = catppuccin_name;
        package = catppuccin;
      };

      # theme = {
      #   name = "Tokyonight-Dark";
      #   package = pkgs.tokyo-night-gtk;
      # };
      # cursorTheme = {
      #   name = "Catppuccin-Macchiato-Dark-Cursors";
      #   package = pkgs.catppuccin-cursors.macchiatoDark;
      # };

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    home = lib.mkIf true {
      #sessionVariables.GTK_THEME = catppuccin_name;
      # file = {
      #   ".config/gtk-4.0/gtk.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk.css";
      #   ".config/gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
      #   ".config/gtk-4.0/assets" = {
      #     recursive = true;
      #     source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/assets";
      #   };
      # };
    };
  };
}
