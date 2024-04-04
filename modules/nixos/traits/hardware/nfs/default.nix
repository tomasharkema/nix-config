{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.nvidia;
in {
  options.traits = {
    hardware.nfs = {
      enable = mkBoolOpt false "nfs";
    };
  };
}
