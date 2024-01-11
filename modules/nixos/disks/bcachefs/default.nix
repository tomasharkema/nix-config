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
                root = {
                  name = "root";
                  end = "-0";
                  content = {
                    type = "filesystem";
                    format = "bcachefs";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };
      };
    };
  }
