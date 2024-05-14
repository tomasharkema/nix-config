{ pkgs, lib, config, osConfig, inputs, ... }:
with lib;
let
  catppuccin_name = "Catppuccin-Mocha-Compact-Blue-Dark";
  # catppuccin = pkgs.catppuccin-gtk.override {
  #   accents = ["blue"];
  #   size = "compact";
  #   tweaks = ["rimless" "black"];
  #   variant = "mocha";
  # };
in {
  imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

  # disabledModules=["home-manager/tofi.nix"];

  options = { programs.tofi.settings = mkOption { }; };

  config = mkIf
    (pkgs.stdenv.isLinux && osConfig.gui.enable && osConfig.gui.gnome.enable) {
      # xsession.pointerCursor = mkIf pkgs.stdenv.isLinux {
      #   name = "macOS-Monterey";
      #   package = pkgs.apple-cursor;
      #   size = 28;
      # };

      catppuccin = {
        enable = true;

        flavour = "mocha";
        accent = "blue";
      };

      gtk = {
        enable = true;

        font = {
          package = pkgs.inter;
          name = "Inter Regular";
          size = 11;
        };

        # theme = lib.mkForce {
        #   name = catppuccin_name;
        #   package = catppuccin;
        # };
        catppuccin = {
          enable = true;
          package = pkgs.catppuccin-gtk;
          flavour = "mocha";
          accent = "blue";
          size = "compact";
          tweaks = [ "black" ];
        };

        cursorTheme = mkForce {
          name = "macOS-Monterey";
          package = pkgs.apple-cursor;
          #   size = 28;
        };

        # theme = {
        #   name = "Tokyonight-Dark";
        #   package = pkgs.tokyo-night-gtk;
        # };
        # cursorTheme = {
        #   name = "Catppuccin-Macchiato-Dark-Cursors";
        #   package = pkgs.catppuccin-cursors.macchiatoDark;
        # };

        # gtk3.extraConfig = {
        #   Settings = ''
        #     gtk-application-prefer-dark-theme=1
        #   '';
        #   gtk-cursor-theme-name = "macOS-Monterey";
        #   gtk-cursor-theme-size = 28;
        # };

        # gtk4.extraConfig = {
        #   Settings = ''
        #     gtk-application-prefer-dark-theme=1
        #   '';
        #   gtk-cursor-theme-name = "macOS-Monterey";
        #   gtk-cursor-theme-size = 28;
        # };
      };
      home = lib.mkIf true {
        # pointerCursor = mkIf pkgs.stdenv.isLinux {
        #   name = "macOS-Monterey";
        #   package = pkgs.apple-cursor;
        #   size = 28;
        #   x11 = {
        #     enable = true;
        #     defaultCursor = "macOS-Monterey";
        #     # size = 32;
        #   };
        # };
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
