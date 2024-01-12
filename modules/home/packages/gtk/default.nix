{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    gtk = let
      catt = pkgs.fetchFromGitHub {
        owner = "Fausto-Korpsvart";
        repo = "Catppuccin-GTK-Theme";
        rev = "b8cffe7583876e17cc4558f32d17a072fa04ea9f";
        hash = "sha256-wJnbXXWKX0mcqRYyE1Vs4CrgWXTwfk3kRC2IhKqQ0RI=";
      };
    in {
      enable = true;
      font = {
        package = pkgs.custom.neue-haas-grotesk;
        name = "Neue Haas Grotesk Display Pro Medium 11";
      };
      theme = {
        name = "Catppuccin-Mocha-Compact-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "compact";
          tweaks = ["rimless" "black"];
          variant = "mocha";
        };
      };
    };
  };
}
