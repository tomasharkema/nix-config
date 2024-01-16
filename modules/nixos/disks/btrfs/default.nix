{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
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
          # keyFile = "/tmp/secret.key";
        };
        # additionalKeyFiles = ["/tmp/additionalSecret.key"];
        content = root;
      };
    };
  };

  innerContent = {
    root = {
      size = "100%";
      content = {
        type = "btrfs";
        extraArgs = ["-f"]; # Override existing partition
        # Subvolumes must set a mountpoint in order to be mounted,
        # unless their parent is mounted
        subvolumes = {
          # Subvolume name is different from mountpoint
          "/rootfs" = {mountpoint = "/";};
          # Subvolume name is the same as the mountpoint
          "/home" = {
            mountOptions = ["subvol=home" "compress=zstd"];
            mountpoint = "/home";
          };
          # "/home-snapshots" = {
          #   mountOptions = ["subvol=home-snapshots" "compress=zstd"];
          #   mountpoint = "/home/.snapshots";
          # };
          # Parent is not mounted so the mountpoint must be set
          "/nix" = {
            mountOptions = [
              "subvol=nix"
              #"compress=zstd"
              "noatime"
            ];
            mountpoint = "/nix";
          };
          # Subvolume for the swapfile
          "/swap" = {
            mountpoint = "/.swapvol";
            swap = {
              swapfile.size = "5G";
            };
          };
          # "/.snapshots" = {
          #   mountpoint = "/.snapshots";

          #   mountOptions = ["subvol=snapshots" "compress=zstd" "noatime"];
          # };
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

      services = {
        btrfs.autoScrub = mkIf cfg.autoscrub {
          enable = true;
          fileSystems = ["/"];
        };
        snapper = {
          snapshotRootOnBoot = true;
          snapshotInterval = "hourly";
          cleanupInterval = "7d";

          configs."home" = {
            SUBVOLUME = "/home";
            TIMELINE_CREATE = true;
            TIMELINE_CLEANUP = true;
            TIMELINE_LIMIT_HOURLY = 2;
            TIMELINE_LIMIT_DAILY = 3;
            TIMELINE_LIMIT_WEEKLY = 1;
            TIMELINE_LIMIT_MONTHLY = 1;
            TIMELINE_LIMIT_YEARLY = 0;
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
        # snapper-gui
        # tpm-luks
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
                        mountOptions = ["subvol=media" "compress=zstd"];
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
