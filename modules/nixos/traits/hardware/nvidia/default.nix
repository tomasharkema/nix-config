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
in {
  options.traits = {
    hardware.nvidia = {
      enable = mkBoolOpt false "nvidia";
    };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["nvidia:${nvidiaVersion}"];

    environment.systemPackages = with pkgs; [
      nvtop
      pkgs.custom.gpustat
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      #netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
      #  nvidia_smi: yes
      #'';
    };

    boot = {
      # initrd.kernelModules = ["nvidia"];
      # extraModulePackages = [config.hardware.nvidia.package];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        nvidiaPersistenced = false;
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
