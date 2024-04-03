{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  config = {
    installed = true;
    # programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [openrgb-with-all-plugins];

    time = {
      # hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    # services.freeipa.replica.enable = true;

    networking = {
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault false;

      interfaces = {
        "enp2s0" = {
          mtu = 9000;
          wakeOnLan.enable = true;
        };
        "eno1" = {
          mtu = 9000;
          wakeOnLan.enable = true;
        };
      };
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      game-mode.enable = true;
      quiet-boot.enable = true;
    };
    # fileSystems."/mnt/media" = {
    #   device = "192.168.0.11:/export/media";
    #   fsType = "nfs";
    # };
    services = {
      hardware = {
        openrgb.enable = true;
        bolt.enable = true;
      };

      udev.packages = [pkgs.openrgb];
      command-center = {
        #enableBot = true;
      };
    };

    apps = {
      steam.enable = true;
      flatpak.enable = true;
    };

    headless.hypervisor = {
      enable = true;
      bridgeInterfaces = ["enp2s0"];
    };

    hardware = {
      nvidia = {
        modesetting.enable = false;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        nvidiaPersistenced = true;
      };
      cpu.intel.updateMicrocode = true;
      i2c.enable = true;
    };

    fileSystems = {
      # "/mnt/blue-fire/media" = {
      #   device = "192.168.0.11:/exports/media";
      #   fsType = "nfs";
      # };
      # "/mnt/unraid/appdata" = {
      #   device = "192.168.0.100:/mnt/user/appdata";
      #   fsType = "nfs";
      # };
      # "/mnt/unraid/appdata_ssd" = {
      #   device = "192.168.0.100:/mnt/user/appdata_ssd";
      #   fsType = "nfs";
      # };
      # "/mnt/unraid/appdata_disk" = {
      #   device = "192.168.0.100:/mnt/user/appdata_disk";
      #   fsType = "nfs";
      # };
      # "/mnt/unraid/data" = {
      #   device = "192.168.0.100:/mnt/user/data";
      #   fsType = "nfs";
      # };
      #   "/mnt/dione" = {
      #     device = "192.168.178.3:/volume1/homes";
      #     fsType = "nfs";
      #   };
    };

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        nvidia.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        disable-sleep.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768639292E";
      encrypt = true;
    };

    boot = {
      # binfmt.emulatedSystems = ["aarch64-linux"];
      supportedFilesystems = ["ntfs"];
      # kernelModules = ["i2c-dev"];
    };

    # boot = {
    #   loader = {
    #     efi = {
    #       canTouchEfiVariables = false;
    #       # efiSysMountPoint = "/boot";
    #     };
    #     grub = {
    #       enable = true;
    #       efiSupport = true;
    #       device = "nodev";
    #       efiInstallAsRemovable = true;
    #     };
    #   };
    # };
  };
}
