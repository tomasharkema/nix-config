{
  pkgs,
  lib,
  config,
  ...
}: let
  btrfsCfg = config.disks.btrfs;
  cfg = btrfsCfg.btrbk;
in {
  options.disks.btrfs.btrbk = {enable = lib.mkEnableOption "btrbk";};

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = btrfsCfg.enable;
        message = "For btrbk, btrfs need to be enabled.";
      }

      {
        assertion = !(btrfsCfg.snapper.enable);
        message = "For btrbk, snapper needs to be off";
      }
    ];

    age.secrets.btrbk = {
      rekeyFile = ./btrbk.age;
      # mode = "600";
      owner = "btrbk";
      group = "btrbk";
    };

    services.btrbk = {
      extraPackages = with pkgs; [zstd mbuffer];

      instances."${config.networking.hostName}-btrbk" = {
        onCalendar = "hourly";

        settings = {
          # snapshot_preserve = "2d";
          snapshot_preserve_min = "2d";

          # target_preserve_min = "no";
          target_preserve = "20d";

          raw_target_compress = "zstd";
          raw_target_split = "100M";

          transaction_syslog = "daemon";

          ssh_identity = "${config.age.secrets.btrbk.path}";
          stream_buffer = "100M";
          backend_remote = "btrfs-progs-sudo";

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
                # raw send-receive
                "raw ssh://dione.local:222/volume1/homes/tomas/backup/btrbk/${config.networking.hostName}" = {
                  ssh_user = "tomas";
                };
              };

              # target = {
              #   "raw ssh://silver-star/mnt/user0/backup/btrbk/${config.networking.hostName}" = {
              #     ssh_user = "root";
              #   };
              # };
            };
          };
        };
      };
    };
  };
}
