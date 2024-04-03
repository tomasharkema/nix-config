{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.disks.btrfs;

  luksContent = root: {
    luks = {
      size = "100%";
      content = {
        type = "luks";
        name = "crypted";
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
            mountOptions = [
            ];
          };
          "home" = {
            mountOptions =
              [
                "noatime"
                "discard=async"
              ]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/home";
          };
          "resilio-sync" = mkIf (cfg.newSubvolumes && cfg.media == null) {
            mountOptions = [
              "noatime"
              "discard=async"
            ];
            mountpoint = "/opt/resilio-sync";
          };
          "resilio-sync-lib" = mkIf cfg.newSubvolumes {
            mountOptions = [
              "noatime"
              "discard=async"
            ];
            mountpoint = "/var/lib/resilio-sync";
          };
          "nix" = mkIf cfg.newSubvolumes {
            mountOptions =
              [
                "noatime"
                "discard=async"
              ]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/nix";
          };
          "containers" = mkIf cfg.newSubvolumes {
            mountOptions =
              [
                "noatime"
                "discard=async"
              ]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/var/lib/containers";
          };
          "swapfile" = mkIf cfg.newSubvolumes {
            mountOptions = [
              "noatime"
              "nodatacow"
              "nodatasum"
              "discard=async"
            ];
            mountpoint = "/swapfile";
          };
          "snapshots" = mkIf cfg.newSubvolumes {
            mountOptions = [
              "noatime"
              "nodatacow"
              "nodatasum"
              "discard=async"
            ];
            mountpoint = "/.snapshots";
          };
          "steam" = mkIf cfg.newSubvolumes {
            mountOptions =
              [
                "noatime"
                "discard=async"
              ]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/opt/steam";
          };
          "flatpak" = mkIf cfg.newSubvolumes {
            mountOptions =
              [
                "noatime"
                "discard=async"
              ]
              ++ lib.optional (!config.traits.low-power.enable) "compress=zstd";
            mountpoint = "/var/lib/flatpak";
          };
          "log" = mkIf cfg.newSubvolumes {
            mountOptions = [
              "noatime"
              "discard=async"
            ];
            mountpoint = "/var/log";
          };
        };

        mountpoint = "/partition-root";
      };
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
      };
    };

    config = mkIf cfg.enable {
      boot = {
        # growPartition = true;
        supportedFilesystems = [
          "btrfs"
        ];
      };

      swapDevices = [
        {
          device = "/swapfile/swapfile";
          size = 16 * 1024;
        }
      ];

      services = {
        btrfs.autoScrub = mkIf cfg.autoscrub {
          enable = true;
          fileSystems = ["/"];
        };
        snapper = {
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
        #       spec = "PARTLABEL=disk-main-root";
        #       hashTableSizeMB = 2048;
        #     };
        #   };
        # };
      };

      environment.systemPackages = with pkgs; [
        dfc
        diskonaut
        erdtree

        snapper
        snapper-gui
        tpm-luks
        btrfs-assistant
        btrfs-snap
        btrfs-progs
        btrfs-heatmap
        btrbk
        timeshift
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

                root = mkIf (!cfg.encrypt) innerContent.root;
                luks =
                  mkIf cfg.encrypt
                  (
                    luksContent innerContent.root.content
                  )
                  .luks;
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
                        mountOptions = [
                          "noatime"
                          "compress=zstd"
                        ];
                        mountpoint = "/opt/media";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };

      systemd.tmpfiles.rules = mkIf (cfg.media != null) [
        "d /opt/media/resilio-sync 0777 rslsync rslsync -"
        "L+ /opt/resilio-sync - - - - /opt/media/resilio-sync"
      ];
    };
  }
