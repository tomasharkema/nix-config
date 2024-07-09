{
  pkgs,
  lib,
  config,
  ...
}:
with lib; {
  options.disks.btrfs.btrbk = {enable = mkEnableOption "btrbk";};

  config = mkIf (config.disks.btrfs.enable && config.disks.btrfs.btrbk.enable) {
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

          target_preserve_min = "no";
          target_preserve = "20d 10w 1m";

          raw_target_compress = "zstd";
          raw_target_split = "100M";

          transaction_syslog = "daemon";
          lockfile = "/run/btrbk.lock";

          ssh_identity = "${config.age.secrets.btrbk.path}";
          stream_buffer = "100M";

          volume = {
            "/partition-root" = {
              subvolume = {
                home = {
                  snapshot_create = "always";
                  snapshot_name = "${config.networking.hostName}-home";
                };
                # rootfs = {
                #   snapshot_name = "${config.networking.hostName}-rootfs";
                # };
              };

              target = {
                "raw ssh://silver-star/mnt/user0/backup/btrbk/${config.networking.hostName}" = {
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
