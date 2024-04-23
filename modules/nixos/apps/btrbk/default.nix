{
  pkgs,
  lib,
  config,
  ...
}: {
  config = with lib; {
    services.btrbk = mkIf config.disks.btrfs.enable {
      extraPackages = with pkgs; [zstd];
      instances."${config.networking.hostName}-btrbk" = {
        settings = {
          snapshot_preserve = "14d";
          snapshot_preserve_min = "2d";
          raw_target_compress = "zstd";
          ssh_identity = "${config.age.secrets.btrbk.path}";
          volume = {
            "/partition-root" = {
              subvolume = {
                home = {
                  snapshot_create = "always";
                };
                rootfs = {};
              };

              target = {
                "raw ssh://192.168.0.100/mnt/user0/backup/btrbk" = {
                  ssh_user = "root";
                };
              };
            };
          };
        };
      };
    };
  };
}
