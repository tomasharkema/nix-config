{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  pkg = pkgs.gptcommit;
in {
  config = {
    home = {
      packages = [pkg];
      #  ${package}/bin/gptcommit config set openai.api_key "$(cat ${osConfig.age.secrets.openai.path})"
      activation = {
        gptcommit = ''
          ${pkg}/bin/gptcommit config set openai.api_base "http://silver_star:11434"
          ${pkg}/bin/gptcommit config set allow-amend true
        '';
      };
    };
  };
}
