{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.hardware.nvidia;
  script = ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" script;
  prime-run = pkgs.writeShellScriptBin "prime-run" script;

  withPatch = patchEnabled: (driver:
    if patchEnabled
    then
      (pkgs.nvidia-patch.patch-nvenc (
        pkgs.nvidia-patch.patch-fbc driver
      ))
    else driver);

  betaPkgs = config.boot.kernelPackages.nvidiaPackages.beta.overrideAttrs ({patches ? [], ...}: {
    patches =
      patches
      ++ [
        # (pkgs.fetchpatch2 {
        #   url = "https://patch-diff.githubusercontent.com/raw/NVIDIA/open-gpu-kernel-modules/pull/1015.patch";
        #   sha256 = "sha256-TNqW9Zth8SED9ueqBMQQRs2XtoQmul5ji1HS43Sp1Kw=";
        # })
      ];
  });

  patchedPkg = withPatch true (
    if cfg.beta
    then betaPkgs
    else config.boot.kernelPackages.nvidiaPackages.stable
  );
in {
  options.traits.hardware.nvidia = {
    enable = lib.mkEnableOption "nvidia";

    beta = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    open = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    grid = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    environment.systemPackages = with pkgs; [
      # nvflash
      # nvidia-capture-sdk
      libva-utils
      (nvtopPackages.full)
      prime-run
      zenith-nvidia
      nvidia-offload
      nvfancontrol
      nvitop
      gwe
      # cudaPackages.cudatoolkit
      egl-wayland
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
      prometheus.exporters.nvidia-gpu.enable = true;
    };

    # environment.extraInit = ''
    #   export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    # '';

    boot = {
      # kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];

      blacklistedKernelModules = ["nouveau"];

      # kernelParams = [
      #   "nvidia-drm.modeset=1"
      #   "nvidia-drm.fbdev=1"
      #   "nvidia_drm.modeset=1"
      #   "nvidia_drm.fbdev=1"
      #   "apm=power_off"
      #   "acpi=force"
      # ];

      # modprobeConfig.enable = true;
      # extraModprobeConfig = ''
      #   options nvidia NVreg_UsePageAttributeTable=1 \
      #     NVreg_InitializeSystemMemoryAllocations=0 \
      #     NVreg_RegistryDwords=RmEnableAggressiveVblank=1
      # '';

      #kernelPackages = lib.mkIf cfg.grid.enable (lib.mkForce pkgs.linuxPackages_6_12);
    };

    hardware = {
      nvidia-container-toolkit.enable = config.virtualisation.docker.enable;

      nvidia = {
        modesetting.enable = lib.mkDefault true;
        # forceFullCompositionPipeline = true;
        open = lib.mkForce cfg.open;
        package = lib.mkIf (!cfg.grid.enable) patchedPkg;
      };

      graphics = {
        enable = true;

        enable32Bit = pkgs.stdenvNoCC.isx86_64;

        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          # libvdpau-va-gl
          # vaapiVdpau
          # egl-wayland
        ];
      };
    };
  };
}
