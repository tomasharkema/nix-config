{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    services.btrbk = {
      instances."${config.networking.hostName}-btrbk" = {
        settings = {
          snapshot_preserve = "14d";
          snapshot_preserve_min = "2d";

          ssh_identity = "${config.age.secrets.btrbk.path}";
          ssh_user = "root";
          stream_compress = "zstd";

          volume = {
            "/partition-root" = {
              subvolume = {
                home = {
                  snapshot_create = "always";
                };
                rootfs = {};
              };
              target = "ssh://192.168.0.100/mnt/user/backup/btrbk";
            };
          };
        };
      };
    };
  };
}
