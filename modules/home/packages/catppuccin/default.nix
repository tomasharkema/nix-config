{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.catppuccin.homeManagerModules.catppuccin];

  config = {
    catppuccin = {
      enable = true;

      flavor = "mocha";
      accent = "blue";
    };

    gtk = {
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
