{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.trait.low-power;
in {
  options.trait.low-power = {
    enable = lib.mkEnableOption "low-power";
  };
  config = lib.mkIf cfg.enable {
    trait.builder.enable = lib.mkForce false;
    apps.resilio.enable = lib.mkForce false;
  };
}
