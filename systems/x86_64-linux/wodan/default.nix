{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: {
  imports = with inputs; [
    ./hardware-configuration.nix

    nvidia-vgpu-nixos.nixosModules.host
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

    networking = {
      hosts = {
        "192.168.0.100" = ["nix-cache.harke.ma"];
      };
      networkmanager.enable = true;

      hostName = "wodan";

      firewall = {
        enable = true;
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
      # kmscon.enable = lib.mkForce false;
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
      };
      # open-webui = {
      #   enable = true;
      #   host = "0.0.0.0";
      # };
    };

    apps = {
      steam = {
        enable = true;
        sunshine = true;
      };
      flatpak.enable = true;
    };

    virtualisation.kvmgt = {
      enable = true;
      device = "0000:01:00.0";
      vgpus = {
        "nvidia-257" = {
          uuid = [
            "c7f90d47-b9b5-497c-b775-d64787e730fb"
            "48644214-af2f-47fb-a924-e51cc8bc1761"
          ];
        };
      };
    };

    services = {
      hypervisor = {
        enable = true;
        bridgeInterfaces = ["enp2s0"];
      };
      xserver.videoDrivers = ["nvidia"];
    };
    programs.mdevctl.enable = true;

    # console.earlySetup = true;

    hardware = {
      # firmware = let
      #   rawFile = pkgs.fetchurl {
      #     url = "https://git.linuxtv.org/edid-decode.git/plain/data/samsung-q800t-hdmi2.1";
      #     sha256 = "0r3v1mzpkalgdhnnjfq8vbg4ian3pwziv0klb80zw89w1msfm9nh";
      #   };
      # in [
      #   (pkgs.runCommandNoCC "samsung-q800t-hdmi2.1" {} ''
      #     mkdir -p $out/lib/firmware/edid/
      #     cp "${rawFile}" $out/lib/firmware/edid/samsung-q800t-hdmi2.1
      #   '')
      # ];

      cpu.intel.updateMicrocode = true;
      i2c.enable = true;
      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia = {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        # open = true;
        nvidiaSettings = lib.mkForce false;
        package = config.boot.kernelPackages.nvidiaPackages.vgpu_17_3;

        vgpu.patcher = {
          enable = true;
          options.doNotForceGPLLicense = false;
          copyVGPUProfiles = {
            # RTX2080     Quadro RTX 4000
            "1E87:0000" = "1E30:12BA";
          };
          enablePatcherCmd = true;
        };
      };
    };

    apps.podman.enable = true;

    traits = {
      server.enable = true;
      builder.enable = true;
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        # nvidia = {
        #   enable = true;
        #   open = true;
        # };
        sgx.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        disable-sleep.enable = true;

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
      supportedFilesystems = ["ntfs"];

      kernelPackages = pkgs.linuxPackages_6_6;

      kernelModules = [
        "i2c-dev"
        "btusb"
        "apfs"
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "kvm-intel"
      ];

      initrd = {
        kernelModules = [
          # "ixgbe"
          # "btusb"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"

          "kvm-intel"
        ];
      };

      # KMS will load the module, regardless of blacklisting
      kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
        # "iomem=relaxed"
        # "drm.edid_firmware=HDMI-A-1:edid/samsung-q800t-hdmi2.1"
        # "video=HDMI-A-1:e"
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
