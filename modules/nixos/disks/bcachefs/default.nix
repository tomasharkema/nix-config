{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.disks.bcachefs;
in
  with lib; {
    options = {
      disks.bcachefs = {
        enable = mkEnableOption "Enable bcachefs";
        autoscrub = mkEnableOption "Enable bcachefs Autoscrub";
        main = mkOption {
          type = types.str;
          description = "Dev for main partion.";
        };
        encrypt = mkEnableOption "encrypted";
      };
    };

    config = mkIf cfg.enable {
      boot.kernelPackages = pkgs.linuxPackages_latest;
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
                    content = {
                      # root = {
                      # name = "root";
                      # end = "-0";
                      # content = {
                      type = "filesystem";
                      format = "bcachefs";
                      mountpoint = "/";
                      # };
                      # };
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
