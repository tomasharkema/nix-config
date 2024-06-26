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

    home.pointerCursor = mkIf pkgs.stdenv.isDarwin (mkForce null);

    # gtk = mkIf config.gtk.enable {
    #   catppuccin = {
    #     enable = true;
    #     flavor = "mocha";
    #     accent = "blue";
    #     size = "compact";
    #     tweaks = ["black"];
    #     gnomeShellTheme = true;
    #   };
    # };
  };
}
