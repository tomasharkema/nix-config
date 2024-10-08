{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    home.file = {
      ".continue/config.json" = {
        source = pkgs.writers.writeJSON "config.json" {
          "models" = [
            {
              title = "llama3";
              provider = "ollama";
              model = "llama3.1:8b";
              apiBase = "http://wodan:11434";
            }
          ];
          "tabAutocompleteModel" = {
            title = "starcoder";
            provider = "ollama";
            model = "starcoder2:3b";
            apiBase = "http://wodan:11434";
          };
          # "slashCommands" = [
          #   {
          #     "name" = "edit";
          #     "description" = "Edit selected code";
          #   }
          #   {
          #     "name" = "comment";
          #     "description" = "Write comments for the selected code";
          #   }
          #   {
          #     "name" = "share";
          #     "description" = "Export the current chat session to markdown";
          #   }
          #   {
          #     "name" = "cmd";
          #     "description" = "Generate a shell command";
          #   }
          #   {
          #     "name" = "commit";
          #     "description" = "Generate a git commit message";
          #   }
          # ];
        };
      };
    };
  };
}
