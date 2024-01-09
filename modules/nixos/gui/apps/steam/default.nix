{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}:
with lib; let
  cfg = config.gui.apps.steam;
in {
  options.gui.apps.steam = {
    enable = mkEnableOption "hallo";
  };

  config = mkIf cfg.enable {
    users.groups.input.members = ["tomas"];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall =
        true;
      dedicatedServer.openFirewall =
        true;
    };

    environment.systemPackages = with pkgs; [
      sunshine
      protontricks
      nvtop
    ];
    services.udev.extraRules = ''
      Sunshine
      KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    '';

    systemd.services.sunshine = {
      enable = true;
      description = "Sunshine self-hosted game stream host for Moonlight.";
      unitConfig = {
        Type = "simple";
        StartLimitIntervalSec = 500;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        ExecStart = "${pkgs.sunshine}";
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = ["graphical-session.target"];
    };

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

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
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # systemd.services.netdata.path = [ pkgs.linuxPackages.nvidia_x11 ];
    services.netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
      nvidia_smi: yes
    '';
  };
}
