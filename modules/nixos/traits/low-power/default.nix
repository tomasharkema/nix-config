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
    apps.resilio.enable = lib.mkForce false;

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };
  };
}
