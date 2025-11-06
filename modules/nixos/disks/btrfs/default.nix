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
          "resilio-sync" = lib.mkIf (cfg.newSubvolumes.enable && cfg.media == null) {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/mnt/resilio-sync";
          };
          "resilio-sync-lib" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"];
            mountpoint = "/var/lib/resilio-sync";
          };
          "nix" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/nix";
          };
          "containers" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/var/lib/containers";
          };
          "snapshots" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/.snapshots";
          };
          "home-snapshots" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/home/.snapshots";
          };
          "steam" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions =
              ["noatime" "discard=async"]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/mnt/steam";
          };
          "log" = lib.mkIf cfg.newSubvolumes.enable {
            mountOptions = ["noatime" "discard=async"] ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
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
      autoscrub.enable = lib.mkEnableOption "Enable BTRFS Autoscrub" // {default = true;};

      newSubvolumes.enable = lib.mkEnableOption "Enable BTRFS newSubvolumes";

      snapper.enable = lib.mkEnableOption "enable snapper" // {default = true;};

      resume.enable = lib.mkEnableOption "Enable BTRFS resume device";

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
      boot = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "override boot device";
      };
      media = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Dev for optional media partition";
      };

      encrypt = lib.mkEnableOption "encrypted";

      swap = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "swap";
        };

        size = lib.mkOption {
          type = lib.types.str;
          default = "16G";
          description = "swap";
        };

        resume.enable = lib.mkEnableOption "Enable BTRFS resume device";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # growPartition = true;
      supportedFilesystems = ["btrfs"];
      initrd.availableKernelModules = ["aesni_intel" "cryptd"];
      kernelModules = [
        # "sha256"
      ];
    };

    services = {
      btrfs.autoScrub = lib.mkIf cfg.autoscrub.enable {
        enable = true;
        fileSystems = ["/"];
        interval = "weekly";
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
      custom.dupremove
    ];

    # fileSystems."/".neededForBoot = true;
    # fileSystems."/boot".neededForBoot = true;

    disko.devices = {
      disk = {
        boot = lib.mkIf (cfg.boot != null) {
          type = "disk";
          device = cfg.boot;
          content = {
            type = "gpt";
            partitions = {
              boot = {
                size = "1M";
                type = "EF02"; # for grub MBR
              };
              ESP = {
                size = "100%";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
            };
          };
        };

        "${cfg.mainOverride}" = {
          type = "disk";
          device = cfg.main;
          content = {
            type = "gpt";
            partitions = {
              boot = lib.mkIf (cfg.boot == null) {
                size = "1M";
                type = "EF02"; # for grub MBR
              };
              ESP = lib.mkIf (cfg.boot == null) {
                size = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };

              swap = lib.mkIf cfg.swap.enable {
                size = cfg.swap.size;
                content = {
                  type = "swap";
                  # randomEncryption = true;
                  resumeDevice = cfg.swap.resume.enable;
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
