{
  lib,
  pkgs,
  config,
  ...
}: let
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
          "/home" = {
            mountOptions = [
              "subvol=home"
              "compress=zstd"
            ];
            mountpoint = "/home";
          };
          "/nix" = {
            mountOptions = [
              # "subvol=nix"
              "noatime"
            ];
            mountpoint = "/nix";
          };
          # "/swapfile" = {
          #               mountOptions = [
          #     # "subvol=nix"
          #     "noatime"
          #   ];
          #   mountpoint = "/swapfile";
          # };
          "/steam" = {
            mountOptions = [
              # "subvol=flatpak"
              "compress=zstd"
              "noatime"
            ];
            # mountpoint = "/steam";
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
          snapshotRootOnBoot = true;
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
              TIMELINE_LIMIT_MONTHLY = 0;
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
              TIMELINE_LIMIT_MONTHLY = 0;
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
        snapper
        snapper-gui
        tpm-luks
        btrfs-assistant
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
                  size = "512M";
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
                    extraArgs = ["-f"]; # Override existing partition
                    # Subvolumes must set a mountpoint in order to be mounted,
                    # unless their parent is mounted
                    subvolumes = {
                      "/media" = {
                        mountOptions = ["subvol=media"];
                        mountpoint = "/media";
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  }
