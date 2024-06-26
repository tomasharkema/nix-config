{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.nvidia;

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.traits = {
    hardware.nvidia = {
      enable = mkBoolOpt false "nvidia";
    };
  };

  config = mkIf cfg.enable {
    # nixpkgs.config = {
    #   nvidia.acceptLicense = true;
    #   cudaSupport = true;
    # };

    environment.systemPackages = with pkgs; [
      nvtopPackages.full
      zenith-nvidia
      nvidia-offload
      gnomeExtensions.prime-helper
      nvfancontrol
      nvitop
      # gwe
    ];

    home-manager.users.tomas.dconf.settings."org/gnome/shell".enabled-extensions = [pkgs.gnomeExtensions.prime-helper.extensionUuid];

    services.supergfxd.enable = true;
    systemd.services.supergfxd.path = [pkgs.pciutils];

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
      initrd.kernelModules = ["nvidia"];
      kernelParams = ["nvidia-drm.modeset=1" "nvidia_drm.fbdev=1" "apm=power_off" "acpi=force"];
    };

    hardware = {
      nvidia = mkDefault {
        modesetting.enable = true;
        forceFullCompositionPipeline = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "555.52.04";
          sha256_64bit = "sha256-nVOubb7zKulXhux9AruUTVBQwccFFuYGWrU1ZiakRAI=";
          sha256_aarch64 = lib.fakeSha256;
          openSha256 = lib.fakeSha256;
          settingsSha256 = "sha256-PMh5efbSEq7iqEMBr2+VGQYkBG73TGUh6FuDHZhmwHk=";
          persistencedSha256 = "sha256-KAYIvPjUVilQQcD04h163MHmKcQrn2a8oaXujL2Bxro=";
        };
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
