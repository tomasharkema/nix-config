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
  cfg = config.disks.zfs;
in
  with lib; {
    options = {
      disks.zfs = {
        enable = mkEnableOption "SnowflakeOS GNOME configuration";
        main = mkOption {
          type = types.str;
          # default = false;
          description = "Enable Nix Software Center, a graphical software center for Nix";
        };
        media = mkOption {
          type = types.str;
          default = null;
          description = "Enable Nix Software Center, a graphical software center for Nix";
        };
      };
    };

    config = mkIf cfg.enable {
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
          zmedia = mkIf (cfg.media != null) {
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
    };
  }
