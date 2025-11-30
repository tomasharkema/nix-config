{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.hardware.nvidia;
in {
  config = {
    virtualisation.kvmgt.enable = true;

    hardware = {
      nvidia = lib.mkMerge [
        (
          if cfg.grid.enable
          then {
            nvidiaSettings = false;
            nvidiaPersistenced = true;

            package = config.boot.kernelPackages.nvidiaPackages.vgpu_17_3.overrideAttrs (self: super: {
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
            });

            vgpu = {
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
          }
          else {}
        )
      ];

      # nvidia =
      #   if cfg.grid.enable
      #   then {
      #     nvidiaSettings = false;
      #     nvidiaPersistenced = true;

      #     vgpu = {
      #       patcher = {
      #         enable = true;
      #         options = {
      #           doNotForceGPLLicense = false;
      #           #   # remapP40ProfilesToV100D = cfg.grid.legacy;
      #         };
      #         copyVGPUProfiles = {
      #           "1E87:0000" = "1E30:12BA";
      #           "1380:0000" = "13BD:1160";
      #         };
      #         enablePatcherCmd = true;
      #       };
      #     };
      #   }
      #   else {};
    };
  };
}
