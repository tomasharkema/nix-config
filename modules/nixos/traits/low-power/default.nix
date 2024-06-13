{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let cfg = config.traits.low-power;
in {
  options.traits = { low-power = { enable = mkBoolOpt false "low-power"; }; };

  config = mkIf cfg.enable {
    traits.builder.enable = mkForce false;
    resilio.enable = mkForce false;
  };
}
