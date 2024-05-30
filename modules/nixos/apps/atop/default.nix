{ pkgs, lib, config, ... }:
with lib;
with lib.custom;
let cfg = config.apps.atop;
in {

  options.apps.atop = {
    enable = mkEnableOption "atop";
    service = mkBoolOpt true "atop service";
    gpu = mkBoolOpt config.traits.hardware.nvidia.enable "atop gpu";
  };

  config = mkIf cfg.enable {

    programs.atop = {
      #   atopRotateTimer.enable = true;
      enable = true;
      setuidWrapper.enable = true;
      atopService.enable = cfg.service;
      #   atopacctService.enable = true;
      atopgpu.enable = cfg.gpu;
      #   netatop.enable = true;
    };
  };
}
