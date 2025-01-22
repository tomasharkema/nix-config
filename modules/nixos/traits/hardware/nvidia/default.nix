{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.hardware.nvidia;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  options.traits.hardware.nvidia = {
    enable = lib.mkEnableOption "nvidia";

    beta = lib.mkOption {
      default = true;
      type = lib.types.bool;
    };
    open = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };

    grid = lib.mkOption {
      default = false;
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    # nixpkgs.config = {
    #   nvidia.acceptLicense = true;
    #   cudaSupport = true;
    # };

    environment.systemPackages = with pkgs; [
      # nvflash
      # nvidia-capture-sdk
      libva-utils
      (nvtopPackages.full)
      zenith-nvidia
      nvidia-offload
      nvfancontrol
      nvitop
      # gwe
      cudaPackages.cudatoolkit
      egl-wayland

      # pkgs.nixgl.auto.nixGLDefault
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
    };

    environment.extraInit = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/run/current-system/sw/lib:/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    '';

    boot = {
      # kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];

      # kernelPackages = lib.mkIf cfg.grid pkgs.linuxPackages_6_11;

      kernelParams = [
        # "nvidia-drm.modeset=1"
        # "nvidia-drm.fbdev=1"
        # "nvidia_drm.modeset=1"
        "nvidia_drm.fbdev=1"

        # "apm=power_off"
        # "acpi=force"
      ];
    };

    hardware = {
      nvidia-container-toolkit.enable = true;

      nvidia = {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = lib.mkForce cfg.open;
        nvidiaSettings = true;

        package =
          if cfg.grid
          then
            config.boot.kernelPackages.nvidiaPackages.vgpu_17_3.overrideAttrs (
              finalAttrs: previousAttrs: {
                # patches =

                #   [
                #     (pkgs.fetchpatch {
                #       url = "https://forums.developer.nvidia.com/uploads/short-url/cC7iLwsUcpxtp4iPZoVpjPvQLz7.txt";
                #       sha256 = "sha256-nDjZPGrZB0P+f7AR1sM+My6O60KYLsk/+nqMTSunXuw=";
                #     })
                #   ];
                meta =
                  previousAttrs.meta
                  // {
                    license = lib.licenses.mit;
                  };
              }
            )
          else
            pkgs.nvidia-patch.patch-nvenc (
              pkgs.nvidia-patch.patch-fbc config.boot.kernelPackages.nvidiaPackages.beta
            );

        vgpu.patcher = lib.mkIf cfg.grid {
          enable = true;
          options = {
            doNotForceGPLLicense = false;
            remapP40ProfilesToV100D = true;
          };
          copyVGPUProfiles = {
            "1E87:0000" = "1E30:12BA";
            "1380:0000" = "13BD:1160";
          };
          enablePatcherCmd = true;
        };
      };

      graphics = {
        enable = true;

        enable32Bit = pkgs.stdenvNoCC.isx86_64;

        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          # libvdpau-va-gl
          vaapiVdpau
          egl-wayland
        ];
      };
    };
  };
}
