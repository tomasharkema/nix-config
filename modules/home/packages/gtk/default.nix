{
  pkgs,
  lib,
  config,
  osConfig,
  # inputs,
  ...
}: let
  # catppuccin_name = "Catppuccin-Mocha-Compact-Blue-Dark";
  # catppuccin = pkgs.catppuccin-gtk.override {
  #   accents = ["blue"];
  #   size = "compact";
  #   tweaks = ["rimless" "black"];
  #   variant = "mocha";
  # };
  cursorSize = 24;
  enable = pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable;
in {
  config = lib.mkIf enable {
    dconf.settings."org/gnome/desktop/interface" = {
      cursor-size = cursorSize;
      cursor-theme = "macOS";
      color-scheme = "prefer-dark";
    };

    # xdg.configFile = {
    #   "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    #   "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    #   "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    # };

    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      font = {
        package = pkgs.inter;
        name = "Inter Display";
        size = 11;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    programs.gnome-shell = {
      enable = true;
      # theme = {
      #   name = "Flat-Remix-Blue-Dark-fullPanel";
      #   package = pkgs.flat-remix-gnome;
      # };
    };

    home = lib.mkIf pkgs.stdenv.isLinux {
      pointerCursor = {
        name = lib.mkForce "macOS";
        package = lib.mkForce pkgs.apple-cursor;
        x11.enable = true;
        gtk.enable = true;
        size = cursorSize;
      };
      # packages = with pkgs; [
      #   flat-remix-gtk
      #   flat-remix-gnome
      #   flat-remix-icon-theme
      # ];

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
