{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.disks.btrfs;

  luksContent = root: name: {
    luks = {
      size = "100%";
      content = {
        type = "luks";
        name = name;
        # disable settings.keyFile if you want to use interactive password entry
        passwordFile = "/tmp/secret.key"; # Interactive
        settings = {
          allowDiscards = true;
          # fallbackToPassword = true;
          # keyFile = "/key/key";
        };

        # keyFile = "/key/hdd.key";

        # additionalKeyFiles = ["/key/key"];
        content = root;
      };
    };
  };

  innerContent = {
    root = {
      size = "100%";
      content = {
        type = "btrfs";
        extraArgs = ["-f"];
        subvolumes = {
          # Subvolume name is different from mountpoint
          "/rootfs" = {
            mountpoint = "/";
            mountOptions = [];
          };
          "home" = lib.mkForce {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/home";
          };
          "resilio-sync" = lib.mkIf (cfg.newSubvolumes && cfg.media == null) {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/mnt/resilio-sync";
          };
          "resilio-sync-lib" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"];
            mountpoint = "/var/lib/resilio-sync";
          };
          "nix" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/nix";
          };
          "containers" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/var/lib/containers";
          };
          "snapshots" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "compress=zstd" "discard=async"];
            mountpoint = "/.snapshots";
          };
          "home-snapshots" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "compress=zstd" "discard=async"];
            mountpoint = "/home/.snapshots";
          };
          "steam" = lib.mkIf cfg.newSubvolumes {
            mountOptions =
              ["noatime" "discard=async"]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/mnt/steam";
          };
          "flatpak" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/var/lib/flatpak";
          };
          "log" = lib.mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "compress=zstd" "discard=async"];
            mountpoint = "/var/log";
          };
        };

        mountpoint = "/partition-root";
      };
    };
  };

  secondContent = {
    size = "100%";
    content = {
      type = "btrfs";
      extraArgs = ["-f"];
      subvolumes = {};

      mountpoint = "/partition-root-2";
    };
  };
in {
  options = {
    disks.btrfs = {
      enable = lib.mkEnableOption "Enable BTRFS";
      autoscrub = lib.mkEnableOption "Enable BTRFS Autoscrub";

      newSubvolumes = lib.mkEnableOption "Enable BTRFS newSubvolumes";

      snapper.enable = lib.mkEnableOption "enable snapper" // {default = true;};

      main = lib.mkOption {
        type = lib.types.str;
        description = "Dev for main partion.";
      };

      second = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "second disk for raid0";
      };

      mainOverride = lib.mkOption {
        type = lib.types.str;
        default = "main";
        description = "Dev for main partion.";
      };
      media = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Dev for optional media partition";
      };
      encrypt = lib.mkEnableOption "encrypted";
      swap = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "swap";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # growPartition = true;
      supportedFilesystems = ["btrfs"];
      initrd.availableKernelModules = ["aesni_intel" "cryptd"];
      kernelModules = ["sha256"];
    };

    services = {
      btrfs.autoScrub = lib.mkIf cfg.autoscrub {
        enable = true;
        fileSystems = ["/"];
      };
      snapper = lib.mkIf cfg.snapper.enable {
        # snapshotRootOnBoot = true;
        snapshotInterval = "hourly";
        cleanupInterval = "1d";

        configs = {
          "home" = {
            SUBVOLUME = "/home";
            ALLOW_USERS = ["tomas" "root"];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
            TIMELINE_LIMIT_HOURLY = 5;
            TIMELINE_LIMIT_DAILY = 7;
            TIMELINE_LIMIT_WEEKLY = 2;
            TIMELINE_LIMIT_MONTHLY = 1;
            TIMELINE_LIMIT_YEARLY = 0;
          };
          "root" = {
            SUBVOLUME = "/";
            ALLOW_USERS = ["tomas" "root"];
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
            TIMELINE_LIMIT_HOURLY = 5;
            TIMELINE_LIMIT_DAILY = 7;
            TIMELINE_LIMIT_WEEKLY = 2;
            TIMELINE_LIMIT_MONTHLY = 1;
            TIMELINE_LIMIT_YEARLY = 0;
          };
        };
      };
      # beesd = {
      #   filesystems = {
      #     root = {
      #       spec = mkDefault "PARTLABEL=disk-main-root";
      #       hashTableSizeMB = mkDefault 2048;
      #     };
      #   };
      # };
    };

    environment.systemPackages = with pkgs; [
      btdu
      snapper
      snapper-gui
      tpm-luks
      btrfs-assistant
      btrfs-snap
      btrfs-progs
      btrfs-heatmap
      btrfs-auto-snapshot
      # btrbk
      # timeshift
    ];

    # fileSystems."/".neededForBoot = true;
    # fileSystems."/boot".neededForBoot = true;

    disko.devices = {
      disk = {
        "${cfg.mainOverride}" = {
          type = "disk";
          device = cfg.main;
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02"; # for grub MBR
              };
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };

              swap = lib.mkIf cfg.swap {
                size = "16G";
                content = {
                  type = "swap";
                  # label = "swap";
                  # randomEncryption = true;
                  resumeDevice = true;
                };
              };
              root = lib.mkIf (!cfg.encrypt) innerContent.root;
              luks =
                lib.mkIf cfg.encrypt
                (luksContent innerContent.root.content "crypted").luks;
            };
          };
        };

        media = lib.mkIf (cfg.media != null) {
          device = cfg.media;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];

                  subvolumes = {
                    "media" = {
                      mountOptions = ["noatime" "compress=zstd"];
                      mountpoint = "/mnt/media";
                    };
                  };
                };
              };
            };
          };
        };
        second = lib.mkIf (cfg.second != null) {
          type = "disk";
          device = cfg.second;

          content = {
            type = "gpt";
            partitions = {
              root = lib.mkIf (!cfg.encrypt) secondContent;
              luks =
                lib.mkIf cfg.encrypt
                (luksContent secondContent.content "crypted-second").luks;
            };
          };
        };
      };
    };
    # finh-leSystems."/home".device = lib.mkForce "/dev/mapper/crypted";
    systemd.tmpfiles.rules = lib.mkIf (cfg.media != null) [
      "d /mnt/media/resilio-sync 0777 rslsync rslsync -"
      "L+ /mnt/resilio-sync - - - - /mnt/media/resilio-sync"
    ];
  };
}
