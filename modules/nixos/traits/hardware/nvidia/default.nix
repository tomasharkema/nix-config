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
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nvtop
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      #netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
      #  nvidia_smi: yes
      #'';
    };

    boot = {
      # initrd.kernelModules = ["nvidia"];
      # extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # nvidiaPersistenced = true;
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
