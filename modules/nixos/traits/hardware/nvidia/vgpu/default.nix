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
      nvidia =
        if cfg.grid.enable
        then {
          nvidiaSettings = false;
          nvidiaPersistenced = true;

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
        else {};
    };
  };
}
