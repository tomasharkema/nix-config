{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  xmm7360 = pkgs.custom.xmm7360-pci.override {
    kernel = config.boot.kernelPackages.kernel;
  };
in {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-intel
    nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsy1IFC8nJp/gFmti2VMz5/pqnY8mZRazM960EhcC4O root@voltron";
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
      btrbk.enable = true;
      snapper.enable = false;
    };

    programs.gnupg.agent = {
      enable = true;
    };

    environment = {
      sessionVariables = {
        # LIBVA_DRIVER_NAME = "i965";
      };

      systemPackages = with pkgs; [
        xmm7360
        libimobiledevice
        intel-gpu-tools
        nvramtool
        libusb
        ccid
        gnupg
        custom.distrib-dl
        # davinci-resolve
        keybase-gui
        # calibre
        glxinfo
        inxi
        pwvucontrol
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

    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
          vaapiVdpau
          vpl-gpu-rt
        ];
      };

      nvidia = {
        forceFullCompositionPipeline = true;

        prime = {
          sync.enable = true;
          offload.enable = false;
          offload.enableOffloadCmd = false;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:02:0:0";
        };

        powerManagement = {
          enable = false;
          # finegrained = true;
        };
      };

      # fancontrol.enable = true;
    };

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

    trait = {
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        laptop.thinkpad.enable = true;
        nvidia = {
          enable = true;
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
      usbmuxd.enable = true;
      # dbus.packages = with pkgs; [custom.ancs4linux];
      # kmscon = {enable = mkForce false;};
      udev = {
        enable = true;
        packages = with pkgs; [
          heimdall-gui
          libusb

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
        #   bridgeInterfaces = ["wlp59s0"];
      };
      # remote-builders.client.enable = true;
      # usb-over-ethernet.enable = true;
      hardware.bolt.enable = true;
      # beesd.filesystems = {
      #   root = {
      #     spec = "UUID=22a02900-5321-481c-af47-ff8700570cc6";
      #     hashTableSizeMB = 4096;
      #     verbosity = "crit";
      #     extraOptions = ["--loadavg-target" "2.0"];
      #   };
      # };

      avahi = {
        enable = true;
        # allowInterfaces = ["wlp59s0"];
        reflector = lib.mkForce false;
      };
    };

    # virtualisation.kvmgt = {
    #   enable = true;
    #   device = "0000:00:02.0";
    #   vgpus = {
    #     "i915-GVTg_V5_4" = {
    #       uuid = ["e2ab260f-44a2-4e07-9889-68a1caafb399"];
    #     };
    #   };
    # };

    programs = {
      # captive-browser = {
      #   enable = true;
      #   interface = "wlp4s0";
      # };

      ccache = {
        enable = true;
        packageNames = [
          #     "freeipa"
          #     "sssd"

          #     "chromium"
          #     "chromium-unwrapped"

          #     "ffmpeg"
          "ffmpeg-full"

          #     "zerotierone"
          #     "ztui"
        ];
      };
    };

    # nix.settings = {
    #   extra-sandbox-paths = [config.programs.ccache.cacheDir];
    # };

    chaotic = {
      scx.enable = pkgs.stdenvNoCC.isx86_64; # by default uses scx_rustland scheduler
    };

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";

      extraModulePackages = [
        xmm7360
      ];

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
        #   # "nowatchdog"
        #   # "mitigations=off"

        #   "intel_iommu=on"
        #   "iommu=pt"
        "blacklist=iosm"
        "blacklist=nouveau"
      ];

      # extraModulePackages = [
      #   config.system.build.isgx
      # ];

      kernelModules = [
        "xmm7360"
        "i915"
        "spi"
        "sgx"
        # "isgx"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        "kvm-intel"
        # "watchdog"
        #"tpm_rng"
      ];
      # extraModprobeConfig = "options i915 enable_guc=2";
      initrd.kernelModules = [
        # "spi"
        # "sgx"
        "i915"
        #  "watchdog"
        # "isgx"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        "kvm-intel"
      ];
    };
  };
}
