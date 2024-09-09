{
  lib,
  pkgs,
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
        type = "filesystem";
        format = "ext4";
        mountpoint = "/";
      };
    };
  };
in {
  options = {
    disks."ext4" = {
      enable = lib.mkEnableOption "Enable EXT4";
      main = lib.mkOption {
        type = lib.types.str;
        description = "Dev for main partion.";
      };
      encrypt = lib.mkEnableOption "encrypted";
      swapSize = lib.mkOption {
        type = lib.types.str;
        default = "2G";
        description = "swapSize";
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                size = cfg.swapSize;
                content = {
                  type = "swap";
                  randomEncryption = true;
                };
              };

              root = lib.mkIf (!cfg.encrypt) (innerContent.root);
              luks =
                lib.mkIf cfg.encrypt
                ((luksContent (innerContent.root.content)).luks);
            };
          };
        };
      };
    };
  };
}
