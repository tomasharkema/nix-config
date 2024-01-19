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
  cfg = config.disks."ext4";

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
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
in
  with lib; {
    options = {
      disks."ext4" = {
        enable = mkEnableOption "Enable BTRFS";
        main = mkOption {
          type = types.str;
          description = "Dev for main partion.";
        };
        encrypt = mkEnableOption "encrypted";
      };
    };

    config = mkIf cfg.enable {
      # boot = {
      #   # growPartition = true;
      #   supportedFilesystems = [
      #     "btrfs"
      #   ];
      # };

      environment.systemPackages = with pkgs; [
        # snapper
        # snapper-gui
        tpm-luks
        # btrfs-assistant
      ];

      # fileSystems."/".neededForBoot = true;
      # fileSystems."/boot".neededForBoot = true;

      disko.devices = {
        disk = {
          main = {
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
        };
      };
    };
  }
