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

    grid = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
      legacy = lib.mkOption {
        default = false;
        type = lib.types.bool;
      };
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
      # egl-wayland

      # pkgs.nixgl.auto.nixGLDefault
    ];

    services = {
      xserver.videoDrivers = ["nvidia"];
      netdata.configDir."python.d.conf" = pkgs.writeText "python.d.conf" ''
        nvidia_smi: yes
      '';
      prometheus.exporters.nvidia-gpu.enable = true;
    };

    environment.extraInit = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    '';

    boot = {
      # kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];

      # kernelPackages = lib.mkIf cfg.grid pkgs.linuxPackages_6_11;
      blacklistedKernelModules = ["nouveau"];

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
        nvidiaSettings = !(cfg.grid.enable);
        package =
          if cfg.grid.enable
          then
            ((
                if cfg.grid.legacy
                then config.boot.kernelPackages.nvidiaPackages.vgpu_16_5
                else
                  (config.boot.kernelPackages.nvidiaPackages.vgpu_17_3.overrideAttrs (finalAttrs: previousAttrs: {
                    prePatch = ''
                      substituteInPlace kernel/nvidia-vgpu-vfio/nvidia-vgpu-vfio.c --replace-fail "no_llseek" "noop_llseek"

                    '';

                    patches = [
                      ./drm.patch
                      # ./6.12.patch
                      # (pkgs.fetchpatch {
                      #      url = "https://gitlab.com/polloloco/vgpu-proxmox/-/raw/master/550.144.02.patch?ref_type=heads&inline=false";
                      #      hash = "sha256-oUSKlGdtB8xklRL/r2dGHfYnhxNarEk1S6WtM20zSS4=";
                      # })
                    ];
                  }))
              )
              .overrideAttrs (
                finalAttrs: previousAttrs: {
                  meta =
                    previousAttrs.meta
                    // {
                      license = lib.licenses.mit;
                    };
                }
              ))
          else let
            # Preferred NVIDIA Version
            nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.mkDriver {
              version = "575.57.08";
              sha256_64bit = "sha256-KqcB2sGAp7IKbleMzNkB3tjUTlfWBYDwj50o3R//xvI=";
              sha256_aarch64 = "sha256-VJ5z5PdAL2YnXuZltuOirl179XKWt0O4JNcT8gUgO98=";
              openSha256 = "sha256-DOJw73sjhQoy+5R0GHGnUddE6xaXb/z/Ihq3BKBf+lg=";
              settingsSha256 = "sha256-AIeeDXFEo9VEKCgXnY3QvrW5iWZeIVg4LBCeRtMs5Io=";
              persistencedSha256 = "sha256-Len7Va4HYp5r3wMpAhL4VsPu5S0JOshPFywbO7vYnGo=";

              patches = [gpl_symbols_linux_615_patch];
            };

            gpl_symbols_linux_615_patch = pkgs.fetchpatch {
              url = "https://github.com/CachyOS/kernel-patches/raw/914aea4298e3744beddad09f3d2773d71839b182/6.15/misc/nvidia/0003-Workaround-nv_vm_flags_-calling-GPL-only-code.patch";
              hash = "sha256-YOTAvONchPPSVDP9eJ9236pAPtxYK5nAePNtm2dlvb4=";
              stripLen = 1;
              extraPrefix = "kernel/";
            };
          in
            nvidiaPackage;

        # pkgs.nvidia-patch.patch-nvenc (
        # pkgs.nvidia-patch.patch-fbc
        # config.boot.kernelPackages.nvidiaPackages.beta
        #)

        vgpu = lib.mkIf (cfg.grid.enable) {
          patcher = {
            enable = true;
            options = {
              doNotForceGPLLicense = false;
              #   # remapP40ProfilesToV100D = cfg.grid.legacy;
            };
            copyVGPUProfiles = {
              "1E87:0000" = "1E30:12BA";
              "1380:0000" = "13BD:1160";
            };
            enablePatcherCmd = true;
          };
        };
      };

      graphics = {
        enable = true;

        enable32Bit = pkgs.stdenvNoCC.isx86_64;

        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          # libvdpau-va-gl
          vaapiVdpau
          # egl-wayland
        ];
      };
    };
  };
}
