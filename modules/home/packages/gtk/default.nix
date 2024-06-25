{
  pkgs,
  lib,
  config,
  osConfig,
  inputs,
  ...
}:
with lib; let
  catppuccin_name = "Catppuccin-Mocha-Compact-Blue-Dark";
  # catppuccin = pkgs.catppuccin-gtk.override {
  #   accents = ["blue"];
  #   size = "compact";
  #   tweaks = ["rimless" "black"];
  #   variant = "mocha";
  # };
  cursorSize = 24;
  enable = pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable;
in {
  config = mkIf enable {
    # xsession.pointerCursor = mkIf pkgs.stdenv.isLinux {
    #   name = "macOS-Monterey";
    #   package = pkgs.apple-cursor;
    #   size = cursorSize;
    # };

    gtk = {
      enable = true;

      font = {
        package = pkgs.inter;
        name = "Inter Regular";
        size = 11;
      };
    };

    home = {
      pointerCursor = {
        name = mkForce "macOS-Monterey";
        package = mkForce pkgs.apple-cursor;
        x11.enable = true;
        gtk.enable = true;
      };

      file = {".config/gnome-initial-setup-done".text = "yes";};

      # sessionVariables.GTK_THEME = "${config.gtk.theme.name}:dark";
      # file = {
      # ".config/gtk-4.0".source = "${config.gtk.theme.package}/share/themes/${catppuccin_name}/gtk-4.0";
      # ".config/gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/gtk-dark.css";
      # ".config/gtk-4.0/assets" = {
      #   recursive = true;
      #   source = "${catppuccin}/share/themes/${catppuccin_name}/gtk-4.0/assets";
      # };
      # };
    };
  };
}
