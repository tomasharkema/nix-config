{
  lib,
  config,
  ...
}: let
  cfg = config.disks.zfs;
in {
  options = {
    disks.zfs = {
      enable = lib.mkEnableOption "SnowflakeOS GNOME configuration";
      main = lib.mkOption {
        type = lib.types.str;
        # default = false;
        description = "Enable Nix Software Center, a graphical software center for Nix";
      };
      media = lib.mkOption {
        type = lib.types.str;
        default = null;
        description = "Enable Nix Software Center, a graphical software center for Nix";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = {
      disk = {
        main = {
          device = cfg.main;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02"; # for grub MBR
              };
              ESP = {
                size = "512M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              zfs = {
                end = "-1G";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
        media = lib.mkIf (cfg.media != null) {
          device = cfg.media;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zmedia";
                };
              };
            };
          };
        };
      };

      zpool = {
        zroot = {
          type = "zpool";
          mode = "";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/";
          postCreateHook = "zfs snapshot zroot@blank";

          datasets = {
            zfs_fs = {
              type = "zfs_fs";
              mountpoint = "/zfs_fs";
              options."com.sun:auto-snapshot" = "true";
            };
          };
        };
        zmedia = lib.mkIf (cfg.media != null) {
          type = "zpool";
          mode = "";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          mountpoint = "/mnt/media";
          postCreateHook = "zfs snapshot zmedia@blank";

          datasets = {
            zfs_fs = {
              type = "zfs_fs";
              mountpoint = "/zfs_fs_media";
              options."com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
