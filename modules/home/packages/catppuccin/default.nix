{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; {
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];

  config = {
    catppuccin = {
      enable = true;

      flavor = "mocha";
      accent = "blue";
    };

    gtk = mkIf config.gtk.enable {
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "blue";
        size = "compact";
        tweaks = ["black"];
        gnomeShellTheme = true;
      };
    };
  };
}
