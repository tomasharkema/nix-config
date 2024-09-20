{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.trait.hardware.intel;
in {
  options.trait.hardware.intel = {
    enable = lib.mkEnableOption "intel";
  };

  config = lib.mkIf cfg.enable {
    hardware = {
      intel-gpu-tools.enable = true;

      graphics = {
        enable = true;
        # driSupport32Bit = true;
        extraPackages = with pkgs; [
          intel-compute-runtime
          vpl-gpu-rt
          intel-media-driver
          # libvdpau-va-gl
          intel-vaapi-driver
        ];
      };
    };
  };
}
