{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.nvidia;

  nvidiaVersion = config.hardware.nvidia.package.version;
  # nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #   export __NV_PRIME_RENDER_OFFLOAD=1
  #   export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #   export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   export __VK_LAYER_NV_optimus=NVIDIA_only
  #   exec "$@"
  # '';
in {
  options.traits = {
    hardware.nvidia = {
      enable = mkBoolOpt false "nvidia";
    };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["nvidia:${nvidiaVersion}"];

    environment.systemPackages = with pkgs; [
      nvtop-nvidia
      zenith-nvidia
      pkgs.custom.gpustat
      # nvidia-offload
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
    };

    boot = {
      initrd.kernelModules = ["nvidia"];
      extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        #        nvidiaPersistenced = false;
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [nvidia-vaapi-driver libvdpau-va-gl vaapiVdpau];
      };
    };
  };
}
