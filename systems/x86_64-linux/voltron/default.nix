{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = with inputs; [
    # ./hardware-configuration.nix
    # nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    # nixos-hardware.nixosModules.common-cpu-intel
    # nixos-hardware.nixosModules.common-gpu-intel
    # nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMESuHxB6/b4HP0S/Ad76XIR5s473hvPXFN8uzjhFZBp root@voltron";
      };
    };

    facter.reportPath = ./facter.json;

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
      # btrbk.enable = true;
      snapper.enable = true; # false;
    };

    # programs.gnupg.agent = {
    #   enable = true;
    # };

    environment = {
      systemPackages = with pkgs; [
        custom.swift

        libimobiledevice
        intel-gpu-tools
        nvramtool
        # libusb
        ccid
        gnupg
        custom.distrib-dl
        # davinci-resolve
        keybase-gui
        # calibre
        glxinfo
        inxi
        pwvucontrol
        usbtop
      ];
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome = {
        enable = true;
        # hidpi.enable = true;
      };
      gamemode.enable = true;
      quiet-boot.enable = true;
    };

    # chaotic.mesa-git.enable = true;

    hardware = {
      mcelog.enable = true;
      nvidia = {
        # forceFullCompositionPipeline = true;

        prime = {
          sync.enable = true;
          # offload.enable = true;
          # offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:02:0:0";
        };

        # powerManagement = {
        # enable = true;
        # finegrained = true;
        # };
      };

      # fancontrol.enable = true;
    };

    virtualisation.waydroid.enable = true;

    apps = {
      steam.enable = true;
      # opensnitch.enable = true;
      # usbip.enable = true;
      # samsung.enable = true;
      podman.enable = true;
      resilio = {
        enable = true;
        enableEnc = true;
      };
    };

    traits = {
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        laptop.thinkpad.enable = true;
        intel.enable = true;
        nvidia = {
          enable = true;
          open = false;
        };
        sgx.enable = true;
        # remote-unlock.enable = true;
        bluetooth.enable = true;
        monitor.enable = true;
      };
    };

    networking = {
      hostName = "voltron"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall = {
        enable = true;

        # trustedInterfaces = ["virbr0" "virbr1" "vnet0"];
      };
    };

    services = {
      abrt.enable = true;
      # remote-builders.client.enable = true;
      usbmuxd.enable = true;
      # power-profiles-daemon.enable = lib.mkForce true;

      ollama = {
        enable = true;
        acceleration = "cuda";
      };

      udev = {
        enable = true;
        packages = with pkgs; [
          heimdall-gui
          # libusb

          # ccid
        ];
      };

      # fprintd.tod.driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
      #   calib-data-file = ./calib-data.bin;
      # };
      switcherooControl.enable = true;
      # journald.storage = "volatile";

      hypervisor = {
        enable = true;
      };

      hardware.bolt.enable = true;
      beesd.filesystems = {
        root = {
          spec = "UUID=89101fa6-b1b1-4922-9ff7-d2d47cba14bd";
          hashTableSizeMB = 1024;
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "2.0"
          ];
        };
      };

      avahi = {
        enable = true;
        reflector = lib.mkForce false;
      };
    };

    virtualisation.kvmgt = {
      enable = true;
      device = "0000:00:02.0";
      vgpus = {
        "i915-GVTg_V5_8" = {
          uuid = ["e2ab260f-44a2-4e07-9889-68a1caafb399"];
        };
      };
    };

    # programs = {
    #   captive-browser = {
    #     enable = true;
    #     interface = "wlp4s0";
    #   };
    # };

    chaotic = {
      scx.enable = pkgs.stdenvNoCC.isx86_64; # by default uses scx_rustland scheduler
    };

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      # resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";

      tmp = {
        useTmpfs = true;
      };

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      binfmt.emulatedSystems = ["aarch64-linux"];

      # modprobeConfig.enable = true;

      kernelParams = [
        "iommu.passthrough=1"

        "iwlwifi.11n_disable=1"
        "iwlwifi.swcrypto=1"
        # "mem_sleep_default=deep"
        #   # "nowatchdog"
        #   # "mitigations=off"
        "i915.enable_gvt=1"
        "i915.enable_guc=0"
        "intel_iommu=on"
        "iommu=pt"
      ];
      blacklistedKernelModules = [
        "nouveau"
      ];

      kernelModules = [
        "pstore"
        "i915"
        "spi"
        # "sgx"
        # "isgx"
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "kvm-intel"
        # "watchdog"
        "usbmon"
      ];
      # extraModprobeConfig = "options i915 enable_guc=2";
      initrd.kernelModules = [
        "pstore"
        # "spi"
        # "sgx"
        "i915"
        #  "watchdog"
        # "isgx"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        # "kvm-intel"
      ];
    };
  };
}
