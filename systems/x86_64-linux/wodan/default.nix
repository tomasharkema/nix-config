{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  config = {
    facter.reportPath = ./facter.json;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8iCdfina2waZYTj0toLyknDT3eJmMtPsVN3iFgnGUR root@wodan";
    };
    # btrfs balance -dconvert=raid0 -mconvert=raid1 /home

    environment.systemPackages = with pkgs; [
      davinci-resolve
      ntfs2btrfs
      glxinfo
      # apfsprogs
      cifs-utils
      piper
      libratbag
      custom.ims-prog
    ];

    time = {
      # hardwareClockInLocalTime = true;
      # timeZone = "Europe/Amsterdam";
    };

    # services.freeipa.replica.enable = true;
    # services.upower.enable = mkForce false;

    networking = {
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = {
        enable = false;
      };

      useDHCP = lib.mkDefault true;

      interfaces = {
        "enp2s0" = {
          mtu = 9000;
          wakeOnLan.enable = true;
          # ipv4.addresses = [
          #   {
          #     address = "192.168.1.170";
          #     prefixLength = 24;
          #   }
          # ];
        };
        "eno1" = {
          mtu = 9000;
          wakeOnLan.enable = true;
        };
      };

      # dhcpcd.extraConfig = ''
      #   interface enp2s0
      #   metric 100

      #   interface eno1
      #   metric 1000
      # '';
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

    # fileSystems."/mnt/dione-downloads" = {
    #   device = "//192.168.1.102/downloads";
    #   fsType = "cifs";
    #   options = let
    #     # this line prevents hanging on network split
    #     automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    #   in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
    # };

    services = {
      kmscon.enable = lib.mkForce true;
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };

        bolt.enable = true;
      };
      ratbagd.enable = true;
      remote-builders.server.enable = true;

      beesd.filesystems = {
        root = {
          spec = "UUID=f3558990-77b0-4113-b45c-3d2da3f46c14";
          hashTableSizeMB = 2048;
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "2.0"
          ];
        };
      };

      ollama = {
        enable = true;
        acceleration = "cuda";
        host = "0.0.0.0";
        loadModels = ["llama3.1:8b" "starcoder2:3b"];
      };
      # open-webui = {
      #   enable = true;
      #   host = "0.0.0.0";
      # };
    };

    apps = {
      steam = {
        enable = true;
        # sunshine = true;
      };
      flatpak.enable = true;
      podman.enable = true;
    };

    # virtualisation.kvmgt = {
    #   enable = true;
    #   device = "0000:01:00.0";
    #   vgpus = {
    #     "nvidia-332" = {
    #       uuid = [
    #         "082b6689-7d8e-4790-ba84-253c91dc4ce7"
    #       ];
    #     };
    #     "nvidia-333" = {
    #       uuid = [
    #         "46d87c24-ae51-4f6a-b0b2-11c7cc652b7f"
    #       ];
    #     };
    #   };
    # };

    services = {
      hypervisor = {
        enable = true;
        bridgeInterfaces = ["enp2s0"];
      };
      xserver.videoDrivers = ["nvidia"];
    };

    programs.mdevctl.enable = true;

    console.earlySetup = true;

    hardware = {
      cpu.intel.updateMicrocode = true;
      i2c.enable = true;
      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia = {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        open = true;
        nvidiaSettings = true;
        nvidiaPersistenced = true;
        # package = config.boot.kernelPackages.nvidiaPackages.vgpu_17_3;

        # vgpu.patcher = {
        #   enable = true;
        #   options.doNotForceGPLLicense = false;
        #   copyVGPUProfiles = {
        #     # RTX2080     Quadro RTX 4000
        #     "1E87:0000" = "1E30:12BA";
        #   };
        #   enablePatcherCmd = true;
        # };
      };
    };

    traits = {
      # server.enable = true;
      # builder.enable = true;
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;

        nvidia = {
          enable = true;
          open = true;
        };

        remote-unlock.enable = true;
        monitor.enable = true;
        # disable-sleep.enable = true;

        # nfs = {
        # enable = true;
        # machines = {
        # silver-star.enable = true;
        # dione.enable = true;
        # };
        # };
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
      # btrbk.enable = true;
      snapper.enable = true; # false;
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
      supportedFilesystems = [
        "ntfs"
        # "apfs"
      ];

      loader.systemd-boot.memtest86.enable = true;

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
        # memtest86.enable = true;
      };
      # kernelPackages = pkgs.linuxPackages_latest;

      kernelModules = [
        "i2c-dev"
        "btusb"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        # "kvm-intel"
        # "nvidia_vgpu_vfio"
      ];

      initrd = {
        kernelModules = [
          # "ixgbe"
          # "btusb"
          # "vfio_pci"
          # "vfio"
          # "vfio_iommu_type1"
          # "nvidia_vgpu_vfio"
          "kvm-intel"
        ];
      };

      # KMS will load the module, regardless of blacklisting
      kernelParams = [
        "console=tty1"
        "console=ttyUSB0,115200n8"
        "intel_iommu=on"
        "iommu=pt"
        # "drm.edid_firmware=HDMI-A-1:edid/samsung-q800t-hdmi2.1"
        # "video=HDMI-A-1:e"
        # "pci-stub.ids=1458:37a7"
      ];

      blacklistedKernelModules = ["nouveau"];
      #extraModprobeConfig = ''
      #  options nvidia-drm modeset=1";
      #  blacklist nouveau
      #  options nouveau modeset=0
      #'';

      # [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };

    systemd.services."serial-getty@ttyUSB0" = {
      wantedBy = ["multi-user.target"];
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
