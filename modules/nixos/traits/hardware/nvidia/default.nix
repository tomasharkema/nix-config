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
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = mkDefault {
      # Modesetting is required.
      modesetting.enable = true;
      forceFullCompositionPipeline = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # systemd.services.netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];
    services.netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
      nvidia_smi: yes
    '';
  };
}
