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

    environment.extraInit = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/run/opengl-driver/lib:/run/opengl-driver-32/lib"
    '';

    boot = {
      # kernelModules = ["nvidia" "nvidia_drm" "nvidia_modeset"];

      blacklistedKernelModules = ["nouveau"];

      kernelParams = [
        # "nvidia-drm.modeset=1"
        # "nvidia-drm.fbdev=1"
        # "nvidia_drm.modeset=1"
        "nvidia_drm.fbdev=1"

        # "apm=power_off"
        # "acpi=force"
      ];

      #kernelPackages = lib.mkIf cfg.grid.enable (lib.mkForce pkgs.linuxPackages_6_12);
    };

    hardware = {
      # nvidia-container-toolkit.enable = true;

      nvidia = {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = lib.mkForce cfg.open;
        package =
          if cfg.grid.enable
          then
            (
              (
                config.boot.kernelPackages.nvidiaPackages.vgpu_17_3.overrideAttrs (self: super: {
                  prePatch = ''
                    ls -la
                    substituteInPlace kernel/nvidia-vgpu-vfio/nvidia-vgpu-vfio.c \
                      --replace-fail '.llseek = no_llseek,' ""
                  '';
                  patches = [
                    # (pkgs.fetchpatch {
                    #   url = "https://raw.githubusercontent.com/moetayuko/nvidia-merged-PKGBUILD/9d6ca572bdca740bfc6ec1760967b66e6d25bd3a/remove_no_llseek.patch";
                    #   sha256 = "sha256-kPnWEiwJZ1Tor0cadsY3chD4C345FHE8+yfhloimSgo=";
                    # })
                    (pkgs.fetchpatch {
                      url = "https://raw.githubusercontent.com/OpenMandrivaAssociation/nvidia/refs/heads/master/nvidia-kernel-6.12.patch";
                      sha256 = "sha256-GVwW+n+8BYm2tBTCNle7Gtsu8z1tmguFvHiw3Ure+C8=";
                    })
                    #     # (pkgs.fetchpatch {
                    #     #   url = "https://raw.githubusercontent.com/moetayuko/nvidia-merged-PKGBUILD/9d6ca572bdca740bfc6ec1760967b66e6d25bd3a/kernel-6.12.patch";
                    #     #   sha256 = "sha256-WtQtUuyaZlwoTpSlXhunS2k0za+Rat9KPdE6WjqjNWs=";
                    #     # })
                    #     # (pkgs.fetchpatch {
                    #     #   url = "https://raw.githubusercontent.com/moetayuko/nvidia-merged-PKGBUILD/9d6ca572bdca740bfc6ec1760967b66e6d25bd3a/make-modeset-fbdev-default.patch";
                    #     #   sha256 = "17y56fq4nyjgc71mg3djd4w5vm3v3lh1nqc02dkgyb1ia84c3s83";
                    #     # })
                    #     # (pkgs.fetchpatch {
                    #     #   url = "https://raw.githubusercontent.com/moetayuko/nvidia-merged-PKGBUILD/9d6ca572bdca740bfc6ec1760967b66e6d25bd3a/nvidia-drm-Set-FOP_UNSIGNED_OFFSET-for-nv_drm_fops.f.patch";
                    #     #   sha256 = "sha256-clE5KdBRKQxKe/27ziwZfyc46Ujegty1l8rKOR32FqI=";
                    #     # })
                  ];
                })
              )
              # .overrideAttrs (
              #   finalAttrs: previousAttrs: {
              #     meta =
              #       previousAttrs.meta
              #       // {
              #         license = lib.licenses.mit;
              #       };
              #   }
            )
          #)
          else
            pkgs.nvidia-patch.patch-nvenc (
              pkgs.nvidia-patch.patch-fbc
              config.boot.kernelPackages.nvidiaPackages.beta
            );
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
