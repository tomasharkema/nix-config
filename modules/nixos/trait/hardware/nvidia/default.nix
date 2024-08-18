{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.trait.hardware.nvidia;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.trait.hardware.nvidia = {
    enable = mkEnableOption "nvidia";
  };

  config = mkIf cfg.enable {
    # nixpkgs.config = {
    #   nvidia.acceptLicense = true;
    #   cudaSupport = true;
    # };

    environment.systemPackages = with pkgs; [
      (nvtopPackages.full)
      zenith-nvidia
      nvidia-offload
      nvfancontrol
      nvitop
      # gwe
    ];

    home-manager.users.tomas.programs.gnome-shell.extensions = [
      {package = pkgs.gnomeExtensions.prime-helper;}
    ];

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

    virtualisation.podman.enableNvidia = true;

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
    };

    boot = {
      kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];
      kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia-drm.fbdev=1"
        # "apm=power_off"
        # "acpi=force"
      ];
      initrd = {
        kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];
        # kernelParams = [
        #   "nvidia-drm.modeset=1"
        #   "nvidia-drm.fbdev=1"
        #   # "apm=power_off"
        #   # "acpi=force"
        # ];
      };
    };

    # TODO: fix!
    # assertions = [
    #   (compareVersion pkgs config.boot.kernelPackages.nvidiaPackages.latest.version config.hardware.nvidia.package.version)
    # ];

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = false;

        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "560.28.03";
        #   sha256_64bit = "";
        #   sha256_aarch64 = lib.fakeSha256;
        #   openSha256 = lib.fakeSha256;
        #   settingsSha256 = "";
        #   persistencedSha256 = lib.fakeSha256;
        # };

        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "560.31.02";
          sha256_64bit = "sha256-0cwgejoFsefl2M6jdWZC+CKc58CqOXDjSi4saVPNKY0=";
          sha256_aarch64 = lib.fakeSha256;
          openSha256 = lib.fakeSha256;
          settingsSha256 = "sha256-A3SzGAW4vR2uxT1Cv+Pn+Sbm9lLF5a/DGzlnPhxVvmE=";
          persistencedSha256 = lib.fakeSha256;
        };
      };

      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          (pkgs.mesa.drivers)
          nvidia-vaapi-driver
          libvdpau-va-gl
          vaapiVdpau
          (config.hardware.nvidia.package)
        ];
      };
    };
  };
}
