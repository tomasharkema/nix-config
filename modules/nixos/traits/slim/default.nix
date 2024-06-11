{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.traits.slim;
in {
  options.traits = { slim = { enable = mkBoolOpt false "slim"; }; };

  config = mkIf cfg.enable {
    traits.builder.enable = mkForce false;
    resilio.enable = mkForce false;
  };
}
