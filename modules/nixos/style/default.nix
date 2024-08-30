{ lib, pkgs, inputs, config, ... }:
with lib; {
  # stylix.nixosModules.stylix
  config = mkIf false {
    # lib.mkIf (config.gui.enable) {
    # system.nixos.tags = ["stylix"];

    # stylix.image = ../../../assets/abstract-colorful-lines-background-digital-art-4k-wallpaper-uhdpaper.com-15.jpg;

    # stylix.polarity = "dark";
    # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # # stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    # stylix.override = {
    #   scheme = "Now it's my scheme >:]";
    #   base00 = "000000"; # make background completely black
    # };

    # # stylix.autoEnable = false;

    # stylix.fonts = lib.mkIf config.gui.enable {
    #   serif = {
    #     package = pkgs.custom.b612;
    #     name = "B612";
    #   };

    #   sansSerif = {
    #     package = pkgs.custom.b612;
    #     name = "B612";
    #   };

    #   monospace = {
    #     package = pkgs.nerdfonts;
    #     name = "JetBrainsMono Nerd Font Mono";
    #   };
    # };

    # home-manager.sharedModules = [
    #   {
    #     stylix.targets.bemenu.enable = false;
    #   }
    # ];
  };
}
