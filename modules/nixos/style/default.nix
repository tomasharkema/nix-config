{
  pkgs,
  inputs,
  config,
  ...
}: {
  stylix.image = ../../../assets/abstract-colorful-lines-background-digital-art-4k-wallpaper-uhdpaper.com-15.jpg;
  # stylix.image = pkgs.fetchurl {
  #   url = "https://image-0.uhdpaper.com/wallpaper/abstract-colorful-lines-background-digital-art-4k-wallpaper-uhdpaper.com-15@0@f.jpg";
  #   sha256 = "sha256-rA4z5DOUYoDufYXDQcIfXm/soU4CXUUhL+1FT1aukjc=";
  # };

  # stylix.polarity = "dark";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.override = {
    scheme = "Now it's my scheme >:]";
    base00 = "000000"; # make background completely black
  };

  # stylix.autoEnable = false;

  stylix.fonts = {
    serif = {
      package = pkgs.custom.b612;
      name = "B612";
    };

    sansSerif = {
      package = pkgs.custom.b612;
      name = "B612";
    };

    monospace = {
      package = pkgs.nerdfonts;
      name = "JetBrainsMono Nerd Font Mono";
    };
  };

  # home-manager.sharedModules = [
  #   {
  #     stylix.targets.bemenu.enable = false;
  #   }
  # ];
}
