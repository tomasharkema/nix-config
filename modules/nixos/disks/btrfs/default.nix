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
in
  with lib; {
    options = {
      disks.btrfs = {
        enable = mkEnableOption "SnowflakeOS GNOME configuration";
        disks = mkOption {
          type = types.listOf types.str;
          # default = false;
          description = "Enable Nix Software Center, a graphical software center for Nix";
        };
      };
    };

    # options.modules.disks = with types; {
    #   btrfs.enable = mkOption {
    #     type = bool;
    #     default = false;
    #     description = "Enable Nix Software Center, a graphical software center for Nix";
    #   };
    # };

    config = mkIf cfg.enable {
      services.btrfs.autoScrub.enable = true;
      services.snapper.snapshotRootOnBoot = true;

      disko.devices = {
        disk = {
          vdb = {
            type = "disk";
            device = builtins.elemAt cfg.disks 0;
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
                      # Sub(sub)volume doesn't need a mountpoint as its parent is mounted
                      "/home/user" = {};
                      # Parent is not mounted so the mountpoint must be set
                      "/nix" = {
                        mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                        mountpoint = "/nix";
                      };
                      # This subvolume will be created but not mounted
                      "/test" = {};
                      # Subvolume for the swapfile
                      "/swap" = {
                        mountpoint = "/.swapvol";
                        swap = {
                          swapfile.size = "20M";
                          swapfile2.size = "20M";
                          swapfile2.path = "rel-path";
                        };
                      };
                    };

                    mountpoint = "/partition-root";
                    swap = {
                      swapfile = {size = "20M";};
                      swapfile1 = {size = "20M";};
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
