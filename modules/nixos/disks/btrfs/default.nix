{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
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
          "home" = {
            mountOptions = ["noatime" "discard=async"]; #++ lib.optional (!config.trait.low-power.enable) "compress=zstd";
            mountpoint = "/home";
          };
          "resilio-sync" = mkIf (cfg.newSubvolumes && cfg.media == null) {
            mountOptions = ["noatime" "compress=zstd" "discard=async"];
            mountpoint = "/mnt/resilio-sync";
          };
          "resilio-sync-lib" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "compress=zstd" "discard=async"];
            mountpoint = "/var/lib/resilio-sync";
          };
          "nix" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"];
            mountpoint = "/nix";
          };
          "containers" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"];
            mountpoint = "/var/lib/containers";
          };
          "snapshots" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "nodatacow" "compress=zstd" "nodatasum" "discard=async"];
            mountpoint = "/.snapshots";
          };
          "home-snapshots" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "nodatacow" "nodatasum" "compress=zstd" "discard=async"];
            mountpoint = "/home/.snapshots";
          };
          "steam" = mkIf cfg.newSubvolumes {
            mountOptions =
              ["noatime" "discard=async"]
              ++ lib.optional (!config.trait.low-power.enable) "compress=zstd";
            mountpoint = "/mnt/steam";
          };
          "flatpak" = mkIf cfg.newSubvolumes {
            mountOptions = ["noatime" "discard=async"];
            mountpoint = "/var/lib/flatpak";
          };
          "log" = mkIf cfg.newSubvolumes {
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
in
  with lib; {
    options = {
      disks.btrfs = {
        enable = mkEnableOption "Enable BTRFS";
        autoscrub = mkEnableOption "Enable BTRFS Autoscrub";

        newSubvolumes = mkEnableOption "Enable BTRFS newSubvolumes";

        main = mkOption {
          type = types.str;
          description = "Dev for main partion.";
        };

        second = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "second disk for raid0";
        };

        mainOverride = mkOption {
          type = types.str;
          default = "main";
          description = "Dev for main partion.";
        };
        media = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Dev for optional media partition";
        };
        encrypt = mkEnableOption "encrypted";
        swap = mkOption {
          type = types.bool;
          default = true;
          description = "swap";
        };
      };
    };

    config = mkIf cfg.enable {
      boot = {
        # growPartition = true;
        supportedFilesystems = ["btrfs"];
        initrd.availableKernelModules = ["aesni_intel" "cryptd"];
      };

      services = {
        btrfs.autoScrub = mkIf cfg.autoscrub {
          enable = true;
          fileSystems = ["/"];
        };
        snapper = {
          snapshotRootOnBoot = true;
          snapshotInterval = "hourly";
          cleanupInterval = "1d";

          configs = {
            "home" = {
              SUBVOLUME = "/home";
              ALLOW_USERS = ["tomas" "root"];
              TIMELINE_CREATE = true;
              TIMELINE_CLEANUP = true;
              TIMELINE_LIMIT_HOURLY = "5";
              TIMELINE_LIMIT_DAILY = "7";
              TIMELINE_LIMIT_WEEKLY = "2";
              TIMELINE_LIMIT_MONTHLY = "1";
              TIMELINE_LIMIT_YEARLY = "0";
            };
            "root" = {
              SUBVOLUME = "/";
              ALLOW_USERS = ["tomas" "root"];
              TIMELINE_CREATE = true;
              TIMELINE_CLEANUP = true;
              TIMELINE_LIMIT_HOURLY = "5";
              TIMELINE_LIMIT_DAILY = "7";
              TIMELINE_LIMIT_WEEKLY = "2";
              TIMELINE_LIMIT_MONTHLY = "1";
              TIMELINE_LIMIT_YEARLY = "0";
            };
          };
        };
        beesd = {
          filesystems = {
            root = {
              spec = mkDefault "PARTLABEL=disk-main-root";
              hashTableSizeMB = mkDefault 2048;
            };
          };
        };
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

      boot.kernelModules = ["sha256"];

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

                swap = mkIf cfg.swap {
                  size = "16G";
                  content = {
                    type = "swap";
                    randomEncryption = true;
                  };
                };
                root = mkIf (!cfg.encrypt) innerContent.root;
                luks =
                  mkIf cfg.encrypt
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
          second = mkIf (cfg.second != null) {
            type = "disk";
            device = cfg.second;

            content = {
              type = "gpt";
              partitions = {
                root = mkIf (!cfg.encrypt) secondContent;
                luks =
                  mkIf cfg.encrypt
                  (luksContent secondContent.content "crypted-second").luks;
              };
            };
          };
        };
      };

      systemd.tmpfiles.rules = mkIf (cfg.media != null) [
        "d /mnt/media/resilio-sync 0777 rslsync rslsync -"
        "L+ /mnt/resilio-sync - - - - /mnt/media/resilio-sync"
      ];
    };
  }
