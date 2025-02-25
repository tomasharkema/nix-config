{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.services.local-store;
in {
  imports = [];

  options.services.local-store = {
    enable = lib.mkEnableOption "local-store";
  };

  config = lib.mkIf (cfg.enable && false) {
    services = {
      nix-serve = {
        enable = true;
        package = pkgs.nix-serve-ng;
      };
    };
  };
}
