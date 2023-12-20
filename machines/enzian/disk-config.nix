{disks ? ["/dev/vda"], ...}: {
  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt disks 0;
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
            encryptedSwap = {
              size = "10M";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            plainSwap = {
              size = "100%";
              content = {
                type = "swap";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };
      media = {
        device = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
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
      zmedia = {
        type = "zpool";
        mode = "";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/media";
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
}
