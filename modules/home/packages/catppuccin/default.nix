{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.catppuccin.homeModules.catppuccin];

  config = {
    catppuccin = {
      enable = true;

      flavor = "mocha";
      accent = "blue";
      cache.enable = false;
    };

    home.pointerCursor = lib.mkIf pkgs.stdenv.isDarwin (lib.mkForce null);

    gtk = lib.mkIf config.gtk.enable {
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "blue";
        size = "compact";
        tweaks = ["black"];
        gnomeShellTheme = true;
        icon.enable = true;
      };
    };
  };
}
