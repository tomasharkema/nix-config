{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: let
  package = pkgs.gptcommit.overrideAttrs (final: {
    patches =
      final.patches
      ++ [
        ./time-gptcommit.patch
      ];
    cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
  });
in {
  config = lib.mkIf false {
    home = {
      packages = [package];
      #  ${package}/bin/gptcommit config set openai.api_key "$(cat ${osConfig.age.secrets.openai.path})"
      activation = {
        gptcommit = ''
          ${package}/bin/gptcommit config set openai.api_base "http://wodan:11434"
          ${package}/bin/gptcommit config set allow-amend true
        '';
      };
    };
  };
}
