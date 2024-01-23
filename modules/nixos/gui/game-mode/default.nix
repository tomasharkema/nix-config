{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.gui.game-mode;
in {
  options.gui.game-mode = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "on";
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };
  };
}
