{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.laptop;
in {
  options.traits = {
    hardware.laptop = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    powerManagement.enable = true;
    services.thermald.enable = true;
  };
}
