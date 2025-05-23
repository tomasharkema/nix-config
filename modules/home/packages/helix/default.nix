{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.helix = {
      enable = true;
      settings = {
        # theme = "autumn_night_transparent";
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          true-color = true;

          lsp = {
            enable = true;
            display-inlay-hints = true;
          };
          auto-save = {focus-lost = true;};
        };
      };
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
        }
      ];
      # themes = {
      #   autumn_night_transparent = {
      #     "inherits" = "autumn_night";
      #     "ui.background" = {};
      #   };
      # };
    };
  };
}
