{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  config = mkIf config.disks.btrfs.enable {
    age.secrets.btrbk = {
      file = ../../../../secrets/btrbk.age;
      mode = "600";
      owner = "btrbk";
      group = "btrbk";
    };

    services.btrbk = {
      extraPackages = with pkgs; [zstd mbuffer];
      instances."${config.networking.hostName}-btrbk" = {
        onCalendar = "hourly";

        settings = {
          snapshot_preserve = "14d";
          snapshot_preserve_min = "2d";

          raw_target_compress = "zstd";
          raw_target_split = "100M";

          transaction_syslog = "daemon";
          lockfile = "/var/lock/btrbk.lock";

          ssh_identity = "${config.age.secrets.btrbk.path}";
          stream_buffer = "50M";

          volume = {
            "/partition-root" = {
              subvolume = {
                home = {
                  snapshot_create = "always";
                  snapshot_name = "${config.networking.hostName}-home";
                };
                rootfs = {
                  snapshot_name = "${config.networking.hostName}-rootfs";
                };
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
