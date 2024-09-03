# background              #1e1e2e
{
  config,
  osConfig,
  pkgs,
  ...
}: {
  config = {
    programs = {
      kitty = {
        enable = true;
        package = pkgs.kitty;
        theme = "Catppuccin-Mocha";

        font = {name = "JetBrainsMono Nerd Font Mono";};

        settings = {
          # font_family = "JetBrainsMono Nerd Font Mono Regular";
          font_size = "13.0";
          background = "#000000";
          #osConfig.variables.theme.withHashtag.base00; #"#000000";
        };

        shellIntegration = {enableZshIntegration = true;};
      };
    };
  };
}
