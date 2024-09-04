{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = {
    home.file = {
      ".continue/config.json" = {
        source = pkgs.writers.writeJSON "config.json" {
          "models" = [
            {
              "title" = "GPT-4o (trial)";
              "provider" = "free-trial";
              "model" = "gpt-4o";
            }
            {
              "title" = "Codestral";
              "provider" = "mistral";
              "model" = "codestral-latest";
            }
          ];
          "tabAutocompleteModel" = {
            "title" = "Codestral (trial)";
            "provider" = "free-trial";
            "model" = "AUTODETECT";
          };
          "slashCommands" = [
            {
              "name" = "edit";
              "description" = "Edit selected code";
            }
            {
              "name" = "comment";
              "description" = "Write comments for the selected code";
            }
            {
              "name" = "share";
              "description" = "Export the current chat session to markdown";
            }
            {
              "name" = "cmd";
              "description" = "Generate a shell command";
            }
            {
              "name" = "commit";
              "description" = "Generate a git commit message";
            }
          ];
        };
      };
    };
  };
}
