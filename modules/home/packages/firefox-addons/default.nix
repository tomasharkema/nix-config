{ config, lib, pkgs, osConfig, ... }:
with lib;
let
  cfg = config.programs.firefox-addons;

  extensionPath = "extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
in {
  options = {
    programs.firefox-addons = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExample ''
        with pkgs.firefox-addons; [
          https-everywhere
          privacy-badger
        ]
      '';
      description = ''
        List of Firefox add-on packages. Note, it is necessary to
        manually enable these add-ons inside Firefox after the first
        installation.
      '';
    };
  };

  config = lib.mkIf osConfig.gui.enable {
    home.file.".mozilla/${extensionPath}" = mkIf (cfg != [ ]) (let
      addonsEnv = pkgs.buildEnv {
        name = "hm-firefox-addons";
        paths = cfg;
      };
    in {
      source = "${addonsEnv}/share/mozilla/${extensionPath}";
      recursive = true;
    });
  };
}
