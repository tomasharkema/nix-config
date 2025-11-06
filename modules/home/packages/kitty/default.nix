# background              #1e1e2e
{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  _1pass-script = pkgs.fetchFromGitHub {
    repo = "kitty-kitten-1password";
    owner = "mm-zacharydavison";
    rev = "main";
    sha256 = "sha256-PiLyOMmBowySBYhbXKL6IhaABcJX4c1F2sRKGUkLAjc=";
  };
in {
  config = lib.mkIf (osConfig.gui.enable) {
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
          notify_on_cmd_finish = "invisible 20";

          copy_on_select = "yes";

          strip_trailing_spaces = "smart";

          map = "ctrl+alt+p kitten ${_1pass-script}/onepassword_kitten.py";
        };

        shellIntegration = {enableZshIntegration = true;};
      };
    };
  };
}
