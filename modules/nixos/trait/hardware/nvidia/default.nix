{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.trait.hardware.nvidia;
  # nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
  #   export __NV_PRIME_RENDER_OFFLOAD=1
  #   export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  #   export __GLX_VENDOR_LIBRARY_NAME=nvidia
  #   export __VK_LAYER_NV_optimus=NVIDIA_only
  #   exec "$@"
  # '';
in {
  options.trait.hardware.nvidia = {
    enable = lib.mkEnableOption "nvidia";

    beta = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    open = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    environment.systemPackages = with pkgs; [
      libva-utils
      (nvtopPackages.full)
      zenith-nvidia
      # nvidia-offload
      nvfancontrol
      nvitop
      # gwe
    ];

    # home-manager.users.tomas.programs.gnome-shell.extensions = [
    #   {package = pkgs.gnomeExtensions.prime-helper;}
    # ];

    # services.supergfxd.enable = true;
    # systemd.services.supergfxd.path = [pkgs.pciutils];

    # environment.sessionVariables = {
    #   VK_DRIVER_FILES =
    #     "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    #   MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
    # };

    # environment.variables = {
    #   VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json";

    #   MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
    # };

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
    };

    boot = {
      # kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];
      kernelParams = [
        # "nvidia-drm.modeset=1"
        # "nvidia-drm.fbdev=1"
        # "nvidia_drm.modeset=1"
        # "nvidia_drm.fbdev=1"

        # "apm=power_off"
        # "acpi=force"
      ];
    };

    hardware = {
      # nvidia-container-toolkit.enable = true;

      nvidia = {
        modesetting.enable = true;
        forceFullCompositionPipeline = true;
        open = lib.mkForce cfg.open;
        nvidiaSettings = true;

        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      graphics = {
        enable = true;

        # enable32Bit = pkgs.stdenvNoCC.isx86_64;

        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libvdpau-va-gl
          vaapiVdpau
        ];
      };
    };
  };
}
