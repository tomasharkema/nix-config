{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom;
with pkgs; let
  cfg = config.apps.attic;
in {
  options.apps.attic = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  config = mkIf (cfg.enable && !config.traits.slim.enable) {
    services.cachix-watch-store = {
      enable = true;
      cacheName = "tomasharkema";
      cachixTokenFile = config.age.secrets.cachix.path;
    };

    services.cachix-agent = {
      enable = true;
    };
  };
}
