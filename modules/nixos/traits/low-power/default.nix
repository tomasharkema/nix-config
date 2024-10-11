{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.low-power;
in {
  options.traits.low-power = {
    enable = lib.mkEnableOption "low-power";
  };
  config = lib.mkIf cfg.enable {
    traits.builder.enable = lib.mkForce false;
    apps.resilio.enable = lib.mkForce false;
  };
}
