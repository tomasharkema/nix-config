{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
with lib; {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-gpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8iCdfina2waZYTj0toLyknDT3eJmMtPsVN3iFgnGUR root@wodan";
    };

    # btrfs balance -dconvert=raid0 -mconvert=raid1 /home

    environment.systemPackages = with pkgs; [
      davinci-resolve
      ntfs2btrfs
      glxinfo
      apfsprogs
    ];

    time = {
      # hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    # services.freeipa.replica.enable = true;
    # services.upower.enable = mkForce false;
    systemd.enableEmergencyMode = true;

    networking = {
      hosts = {"192.168.0.100" = ["nix-cache.harke.ma"];};
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = {enable = false;};
      useDHCP = mkDefault false;

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
      gnome = {
        hidpi.enable = true;
      };
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
      command-center = {
        #enableBot = true;
      };
      remote-builders.server.enable = true;
      beesd.filesystems = {
        root = {
          spec = "UUID=f3558990-77b0-4113-b45c-3d2da3f46c14";
          hashTableSizeMB = 4096;
          verbosity = "crit";
          extraOptions = ["--loadavg-target" "2.0"];
        };
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

    # console.earlySetup = true;

    hardware = {
      cpu.intel.updateMicrocode = true;
      i2c.enable = true;
      enableAllFirmware = true;
      enableRedistributableFirmware = true;
    };

    apps.podman.enable = true;

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

    # swapDevices = [{
    #   device = "/dev/disk/by-partuuid/b1fe4821-e631-494e-bb76-4e9ae272789a";
    #   size = 16 * 1024;
    #   randomEncryption.enable = true;
    # }];

    disks.btrfs = {
      enable = true;

      main = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768639292E";
      second = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768637D1FE";

      encrypt = true;
      newSubvolumes = true;
      btrbk.enable = true;
    };

    #    hardware.nvidia.vgpu = {
    #      enable = true;
    #      unlock.enable = true;
    #      version = "v17.1";
    #    };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
      supportedFilesystems = ["ntfs"];
      kernelModules = ["i2c-dev" "ixgbe" "btusb" "apfs"];

      initrd = {
        systemd.emergencyAccess = "abcdefg";
        kernelModules = ["ixgbe" "btusb"];
      };

      # KMS will load the module, regardless of blacklisting
      kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
      ];
      blacklistedKernelModules = lib.mkDefault ["nouveau"];
      #extraModprobeConfig = ''
      #  options nvidia-drm modeset=1";
      #  blacklist nouveau
      #  options nouveau modeset=0
      #'';

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
