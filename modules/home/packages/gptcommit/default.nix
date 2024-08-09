{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
with lib; let
  package = pkgs.gptcommit;
in {
  config = {
    home = {
      packages = [package];

      activation = {
        gptcommit = ''
          ${package}/bin/gptcommit config set openai.api_key "$(cat ${osConfig.age.secrets.openai.path})"
          ${package}/bin/gptcommit config set allow-amend true
        '';
      };
    };
  };
}
