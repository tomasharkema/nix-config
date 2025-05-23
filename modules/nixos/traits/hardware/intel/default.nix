{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.hardware.intel;
in {
  options.traits.hardware.intel = {
    enable = lib.mkEnableOption "intel";
  };

  config = lib.mkIf cfg.enable {
    environment. sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

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
