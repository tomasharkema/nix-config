{ config, pkgs, lib, ... }:
with lib;
with lib.custom;
let
  cfg = config.traits.hardware.nvidia;

  nvidiaVersion = config.hardware.nvidia.package.version;
  nvidiax11Version = config.boot.kernelPackages.nvidia_x11.version;
  # nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #   export __NV_PRIME_RENDER_OFFLOAD=1
  #   export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #   export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   export __VK_LAYER_NV_optimus=NVIDIA_only
  #   exec "$@"
  # '';
in {
  options.traits = {
    hardware.nvidia = { enable = mkBoolOpt false "nvidia"; };
  };

  config = mkIf cfg.enable {

    nixpkgs.pkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    system.nixos.tags =
      [ "nvidia:${nvidiaVersion}:nvidiax11Version:${nvidiax11Version}" ];

    environment.systemPackages = with pkgs; [
      nvtop-nvidia
      zenith-nvidia
      pkgs.custom.gpustat
      # nvidia-offload
    ];

    environment.sessionVariables = {
      VK_DRIVER_FILES =
        "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
    };

    environment.variables = {
      VK_DRIVER_FILES =
        "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

      MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
    };

    services = {
      xserver.videoDrivers = [ "nvidia" ];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
    };

    boot = {
      initrd.kernelModules = [ "nvidia" ];
      extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          pkgs.mesa.drivers
          nvidia-vaapi-driver
          libvdpau-va-gl
          vaapiVdpau
          config.hardware.nvidia.package

        ];
      };
    };
  };
}
