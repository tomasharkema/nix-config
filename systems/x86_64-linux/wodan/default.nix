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

    environment = {
      systemPackages = with pkgs; [
        davinci-resolve
        ntfs2btrfs
        glxinfo
        # apfsprogs
        cifs-utils
        piper
        libratbag

        heimdall
        heimdall-gui
        handbrake
        davinci-resolve
      ];
    };

    time = {
      # hardwareClockInLocalTime = true;
      timeZone = "Europe/Amsterdam";
    };

    networking = {
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = {enable = false;};

      useDHCP = false;

      bridges.br0 = {
        interfaces = [
          "eno1"
          # "enp2s0"
        ];
      };
      search = ["lan"];
      defaultGateway = {
        address = "192.168.1.1";
        interface = "br0";
      };

      interfaces = {
        "eno1" = {
          mtu = 9000;
          wakeOnLan.enable = true;
          useDHCP = false; # true;
        };
        # enp2s0 = {
        #   mtu = 9000;
        #   wakeOnLan.enable = true;
        #   useDHCP = false;
        # };
        "br0" = {
          useDHCP = false;
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.1.170";
              prefixLength = 24;
            }
          ];
        };

        # "eno1" = {
        #   mtu = 9000;
        #   wakeOnLan.enable = true;
        # };
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
      hidpi.enable = true;
      gnome = {};
    };

    services = {
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
        };

        bolt.enable = true;
      };
      ratbagd.enable = true;
      remote-builders.server.enable = true;
      watchdogd.enable = true;
      beesd.filesystems = lib.mkIf false {
        root = {
          spec = "UUID=f3558990-77b0-4113-b45c-3d2da3f46c14";
          hashTableSizeMB = 2048;
          verbosity = "crit";
          extraOptions = ["--loadavg-target" "2.0"];
        };
      };
    };

    apps = {
      steam = {
        enable = true;
        # sunshine = true;
      };
      ollama.enable = true;
      flatpak.enable = true;
      podman.enable = true;
      ddc.enable = true;
    };

    virtualisation.waydroid.enable = true;

    chaotic.hdr = {
      enable = true;
      specialisation.enable = false;
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
    # ];
    #     };
    #   };
    # };

    services = {
      hypervisor = {
        enable = true;
        bridgeInterfaces = ["enp2s0"];
      };
      xserver.videoDrivers = ["nvidia"];
      ddccontrol.enable = true;
    };
    programs = {
      light = {
        enable = true;
        brightnessKeys = {enable = true;};
      };
      adb.enable = true;
      wireshark = {
        enable = true;
        usbmon.enable = true;
        dumpcap.enable = true;
      };
    };

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

        powerManagement = {
          # enable = true;
          # finegrained = true;
        };

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
        sgx.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        bluetooth.enable = true;
        disable-sleep.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;

      main = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768639292E";
      second = "/dev/disk/by-id/nvme-KINGSTON_SNV2S1000G_50026B768637D1FE";

      encrypt = true;
      newSubvolumes.enable = true;
      # btrbk.enable = true;
      snapper.enable = true; # false;
      swap.size = "64G";
    };

    boot = {
      tmp = {useTmpfs = true;};
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

      extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
      kernelModules = [
        #"i2c-dev"
        "btusb"
        "ddcci"
        "ddcci-backlight"
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
          # "kvm-intel"
        ];
      };

      # KMS will load the module, regardless of blacklisting
      kernelParams = [
        # "console=tty1"
        # "console=ttyUSB0,115200n8"
        "intel_iommu=on"
        "iommu=pt"
        "preempt=full"
        # "drm.edid_firmware=HDMI-A-1:edid/samsung-q800t-hdmi2.1"
        # "video=HDMI-A-1:e"
        # "pci-stub.ids=1458:37a7"
      ];

      # blacklistedKernelModules = ["nouveau"];
      # extraModprobeConfig = ''
      #   options nvidia NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100
      # '';
      #  options nvidia-drm modeset=1";
      #  blacklist nouveau
      #  options nouveau modeset=0
      #'';

      # [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };

    # systemd.services."serial-getty@ttyUSB0" = {
    #   wantedBy = ["multi-user.target"];
    # };
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
