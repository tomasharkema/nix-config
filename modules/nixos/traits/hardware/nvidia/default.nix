{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.nvidia;
in {
  options.traits = {
    hardware.nvidia = {
      enable = mkBoolOpt false "nvidia";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.boot.kernelPackages.nvidia_x11.version == config.boot.kernelPackages.nvidiaPackages.stable.version;
        message = "VERSION: ${config.boot.kernelPackages.nvidia_x11.version}";
      }
    ];

    system.nixos.tags = ["nvidia-${config.boot.kernelPackages.nvidia_x11.version}"];

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
      initrd.kernelModules = ["nvidia"];
      # extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;

        nvidiaPersistenced = false;
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    #    systemd.services.netdata.path = [pkgs.linuxPackages.nvidia_x11];
  };
}
