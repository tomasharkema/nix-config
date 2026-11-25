{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    programs.ghidra = {
      enable = true;
      package = pkgs.ghidra.withExtensions (
        p:
          with p; [
            ret-sync
            gnudisassembler
            machinelearning
            findcrypt
            lightkeeper
            reva
            ghidra-delinker-extension
            # ghidra-firmware-utils
            ghidra-golanganalyzerextension
            ghidraninja-ghidra-scripts
            pkgs.custom.esp8266-loader
            pkgs.custom.ghidra-uf2loader
          ]
      );
    };
  };
}
