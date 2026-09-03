{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.monitor;
in {
  options.traits.hardware.monitor = {enable = lib.mkEnableOption "monitor";};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["monitor"];
    apps.ddc.enable = true;
  };
}
