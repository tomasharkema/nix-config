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

    age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8iCdfina2waZYTj0toLyknDT3eJmMtPsVN3iFgnGUR root@wodan";

    # btrfs balance -dconvert=raid0 -mconvert=raid1 /home

    environment = {
      systemPackages = with pkgs; [
        snmpcheck
        davinci-resolve
        ntfs2btrfs
        # glxinfo
        # apfsprogs
        cifs-utils
        piper
        libratbag
        heimdall
        heimdall-gui
        esp-idf-full
      ];
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

    # system.includeBuildDependencies = true;

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
          # "eno1"
          "enp2s0"
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
        enp2s0 = {
          mtu = 9000;
          wakeOnLan.enable = true;
          useDHCP = false;
        };
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
      };
      gamemode.enable = true;
      quiet-boot.enable = true;
      hidpi.enable = true;
      hdr.enable = true;
      # hyrland.wluma.enable = true;
    };

    services = {
      hardware = {
        openrgb = {
          enable = true;
          package = pkgs.openrgb-with-all-plugins;
          startupProfile = "default";
        };

        bolt.enable = true;
      };
      lldpd.enable = true;
      input-remapper = {
        enable = true;
        enableUdevRules = true;
      };

      kmscon.enable = true;
      syncplay.enable = true;
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
      flatpak.enable = true;
      docker.enable = true;
      ddc.enable = true;
    };

    virtualisation.waydroid.enable = true;

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
      xserver = {
        enableTearFree = true;
        videoDrivers = ["nvidia"];
      };
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
      cpu-energy-meter.enable = true;
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
        # nvidiaPersistenced = lib.mkForce true;

        powerManagement = {
          enable = true;
          # finegrained = true;
        };

        # package = config.boot.kernelPackages.nvidiaPackages.beta;

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

      server.headless.enable = true;
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;

        nvidia = {
          enable = true;
          open = true;
          beta = true;
        };
        sgx.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        bluetooth.enable = true;
        disable-sleep.enable = true;
      };
    };

    boot = {
      tmp = {useTmpfs = true;};
      binfmt.emulatedSystems = ["aarch64-linux"];

      swraid.enable = true;
      supportedFilesystems = [
        "xfs"
        "ntfs"
        # "apfs"
        "ext4"
        "btrfs"
      ];

      loader.systemd-boot.memtest86.enable = true;

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
        # memtest86.enable = true;
      };

      extraModulePackages = with config.boot.kernelPackages; [
        ddcci-driver
        it87
      ];

      kernelModules = [
        "it87"
        "i2c-dev"
        "btusb"
        "ddcci"
        # "iTCO_wdt"
        "ddcci-backlight"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        # "kvm-intel"
        # "nvidia_vgpu_vfio"
      ];

      extraModprobeConfig = ''
        options it87 ignore_resource_conflict=1 update_vbat=1
      '';

      initrd = {
        # compressor = pkgs: "${pkgs.lz4.out}/bin/lz4";
        # compressorArgs = ["-9"];

        compressor = "zstd";
        compressorArgs = ["-9"];

        kernelModules = [
          # "iTCO_wdt" # "ixgbe"
          # "btusb"
          # "vfio_pci"
          # "vfio"
          # "vfio_iommu_type1"
          # "nvidia_vgpu_vfio"
          # "kvm-intel"
        ];
      };

      kernelParams = [
        # "console=tty1"
        # "console=ttyS0,115200n8r"
        "intel_iommu=on"
        "iommu=pt"
        "preempt=full"
        # "drm.edid_firmware=HDMI-A-1:edid/samsung-q800t-hdmi2.1"
        # "video=HDMI-A-1:e"
        # "pci-stub.ids=1458:37a7"
      ];

      blacklistedKernelModules = ["nouveau"];

      #   options nvidia NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100
      #
      #  options nvidia-drm modeset=1";
      #  blacklist nouveau
      #  options nouveau modeset=0
      #'';

      # [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };

    systemd.services."serial-getty@ttyS0" = {
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
# i2c dongle:
#
# echo bh1750 0x23 | sudo tee /sys/class/i2c-dev/i2c-6/device/new_device
#
# KERNEL[1708.952658] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2 (usb)
# KERNEL[1708.952755] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2 (usb)
# KERNEL[1708.959380] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0 (usb)
# KERNEL[1708.960645] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E (hid)
# KERNEL[1708.960794] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/hidraw/hidraw8 (hidraw)
# KERNEL[1709.011672] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/i2c-6/i2c-dev/i2c-6 (i2c-dev)
# KERNEL[1709.011754] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/i2c-6 (i2c)
# KERNEL[1709.011851] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/gpiochip1 (gpio)
# KERNEL[1709.011953] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/gpiochip1 (gpio)
# KERNEL[1709.012073] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E (hid)
# KERNEL[1709.012191] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0 (usb)
# UDEV  [1709.059586] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2 (usb)
# UDEV  [1709.066445] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2 (usb)
# UDEV  [1709.073548] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0 (usb)
# UDEV  [1709.078721] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E (hid)
# UDEV  [1709.085438] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/gpiochip1 (gpio)
# UDEV  [1709.085551] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/i2c-6/i2c-dev/i2c-6 (i2c-dev)
# UDEV  [1709.090367] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/gpiochip1 (gpio)
# UDEV  [1709.090500] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/i2c-6 (i2c)
# UDEV  [1709.092477] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E/hidraw/hidraw8 (hidraw)
# UDEV  [1709.097124] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000E (hid)
# UDEV  [1709.102586] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0 (usb)
#
# KERNEL[2781.182393] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023 (i2c)
# KERNEL[2781.191194] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023/iio:device0 (iio)
# KERNEL[2781.191324] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023 (i2c)
# UDEV  [2781.284107] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023 (i2c)
# UDEV  [2781.290087] add      /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023/iio:device0 (iio)
# UDEV  [2781.294668] bind     /devices/pci0000:00/0000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:10C4:EA90.000F/i2c-6/6-0023 (i2c)

