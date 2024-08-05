{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.trait.low-power;
in {
  options.trait.low-power = {
    enable = mkEnableOption "low-power";
  };
  config = mkIf cfg.enable {
    trait.builder.enable = mkForce false;
    resilio.enable = mkForce false;
  };
}
