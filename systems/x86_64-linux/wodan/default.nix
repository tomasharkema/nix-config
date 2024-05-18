{ pkgs, lib, inputs, config, ... }:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
  ];

  config = {
    # btrfs balance -dconvert=raid0 -mconvert=raid1 /home

    # programs.gamemode.enable = true;
    environment.systemPackages = with pkgs; [
      ntfs2btrfs
      # openrgb-with-all-plugins
      glxinfo
    ];

    time = {
      # hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    # services.freeipa.replica.enable = true;
    # services.upower.enable = mkForce false;

    networking = {
      hosts = { "192.168.0.100" = [ "nix-cache.harke.ma" ]; };
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = { enable = false; };
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
      gamemode.enable = true;
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

      udev.packages = [ pkgs.openrgb ];
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
      bridgeInterfaces = [ "enp2s0" ];
    };
    services.beesd.filesystems = {
      root = {
        spec = "UUID=f3558990-77b0-4113-b45c-3d2da3f46c14";
        hashTableSizeMB = 4096;
        verbosity = "crit";
        extraOptions = [ "--loadavg-target" "2.0" ];
      };
    };

    console.earlySetup = true;

    hardware = {
      nvidia = {
        # modesetting.enable = false;
        # package = config.boot.kernelPackages.nvidiaPackages.stable;
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

        nfs = {
          # enable = true;

          machines = {
            # silver-star.enable = true;
            # dione.enable = true;
          };
        };
      };
    };

    disks.btrfs = {
      enable = true;

      main = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768639292E";
      second = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768637D1FE";

      encrypt = true;
      newSubvolumes = true;
      swapSize = 64 * 1024;
    };

    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      supportedFilesystems = [ "ntfs" ];
      kernelModules = [ "i2c-dev" ];
      # blacklistedKernelModules = lib.mkDefault [ "i915" "nouveau" ];
      # KMS will load the module, regardless of blacklisting
      # kernelParams = lib.mkDefault [ "i915.modeset=0" ];

      #extraModprobeConfig = ''
      #  options nvidia-drm modeset=1";
      #  blacklist nouveau
      #  options nouveau modeset=0
      #'';

      # initrd.kernelModules =
      # [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
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
