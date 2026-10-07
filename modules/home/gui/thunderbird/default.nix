{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}: let
  enabled = osConfig.gui.enable && pkgs.stdenv.hostPlatform.isLinux;
in {
  config = lib.mkIf enabled {
    programs.thunderbird = {
      enable = true;

      profiles = {
        "Tomas Harkema" = {
          isDefault = true;
        };
      };
    };
  };
}
