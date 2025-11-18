{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  # imports = with inputs; [
  #   nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
  # ];
  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfS9/wOr6ZLrC/ifVIqd1avDRj3UftyIRExYs6jg22b root@dell-2";
      };
    };

    facter = {
      reportPath = ./facter.json;
    };

    # qt.enable = lib.mkForce false;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-KXG50ZNV1T02_NVMe_TOSHIBA_1024GB_78OS10V1T8KQ_1";
      encrypt = true;
      newSubvolumes.enable = true;
      # btrbk.enable = true;
      snapper.enable = true; # false;
      swap = {
        size = "32G";
        # resume.enable = false;
        resume.enable = true;
      };
    };

    # programs.gnupg.agent = {
    #   enable = true;
    # };

    systemd = {
      sleep.extraConfig = ''
        MemorySleepMode=deep
      '';
    };
    #   services.usbmuxd.path = [pkgs.libusb1];

    # };

    #system.etc.overlay.enable = true;

    environment = {
      systemPackages = with pkgs; [
        # gt
        gnomeExtensions.power-tracker
        # custom.swift
        powerstat
        powerjoular
        libimobiledevice
        intel-gpu-tools
        nvramtool
        libusb1
        ccid
        gnupg
        custom.distrib-dl
        # davinci-resolve
        keybase-gui
        # calibre
        # glxinfo
        inxi
        pwvucontrol
        i2c-tools
        piper
        libratbag
      ];
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      # hdr.enable = true;
      gnome.enable = true;
      hidpi.enable = true;
      gamemode.enable = true;
      quiet-boot.enable = true;
      # hyrland.wluma = {
      #   enable = true;
      #   backlightDevice = "/sys/class/backlight/intel_backlight";
      # };
    };

    hardware = {
      # mcelog.enable = true;
      # usb-modeswitch.enable = true;
      # fw-fanctrl.enable = true;
      nvidia = {
        forceFullCompositionPipeline = true;
        modesetting.enable = true;
        prime = {
          sync.enable = true;
          # reverseSync.enable = true;
          # offload.enable = true;
          # offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:01:0:0";
        };

        powerManagement = {
          enable = true;
          # finegrained = true;
        };
      };

      # fancontrol.enable = true;
    };

    virtualisation.waydroid.enable = true;

    apps = {
      steam.enable = true;
      # opensnitch.enable = true;
      # usbip.enable = true;
      # samsung.enable = true;
      # docker.enable = true;
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
      # hostName = "voltron"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall = {
        enable = true; # wlp4s0; # false;
        allowPing = true;
        trustedInterfaces = ["virbr0" "virbr1" "vnet0"];
      };
    };

    users = {
      groups = {
        spi = {};
        gpio = {};
      };
      users.tomas.extraGroups = ["spi" "gpio" "docker"];
    };

    # security.pam.services.login.fprintAuth = lib.mkForce false;

    services = {
      thermald.enable = true;

      # fprintd = {
      #   enable = true;
      #   tod = {
      #     enable = true;
      #     driver = pkgs.libfprint-2-tod1-goodix;
      #   };
      # };
      # netdata.enable = false;
      resolved = {
        enable = true;
        # dnssec = "true";
        # domains = ["~."];
        #fallbackDns = ["1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
        #dnsovertls = "true";
      };

      kmscon.enable = true;
      ratbagd.enable = true;
      # comin.enable = false;
      abrt.enable = true;
      # remote-builders.client.enable = true;
      usbmuxd.enable = true;
      # power-profiles-daemon.enable = lib.mkForce true;

      clamav.daemon.settings.MaxThreads = 4;

      udev = {
        enable = true;

        # extraRules = ''
        #   SUBSYSTEM=="usb", ATTRS{idVendor}=="27c6", ATTRS{idProduct}=="5395", \
        #     ATTRS{dev}=="*", TEST=="power/control", ATTR{power/control}="auto", \
        #     MODE="0660", GROUP="plugdev"
        #   SUBSYSTEM=="usb", ATTRS{idVendor}=="27c6", ATTRS{idProduct}=="5395", \
        #     ENV{LIBFPRINT_DRIVER}="Goodix Fingerprint Sensor"
        # '';
        #
        # extraRules = ''
        #   SUBSYSTEM=="spidev", KERNEL=="spidev0.0", GROUP="spi", MODE="0660"

        #   SUBSYSTEM=="gpio", KERNEL=="gpiochip*", ACTION=="add", RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys/class/gpio/export /sys/class/gpio/unexport ; chmod 220 /sys/class/gpio/export /sys/class/gpio/unexport'"
        #   SUBSYSTEM=="gpio", KERNEL=="gpio*", ACTION=="add",RUN+="${pkgs.bash}/bin/bash -c 'chown root:gpio /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value ; chmod 660 /sys%p/active_low /sys%p/direction /sys%p/edge /sys%p/value'"

        # '';
        packages = with pkgs; [
          heimdall-gui
          libusb1
          platformio-core.udev

          # ccid
        ];
      };

      # fprintd.tod.driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
      #   calib-data-file = ./calib-data.bin;
      # };
      # switcherooControl.enable = true;
      # journald.storage = "volatile";

      # hypervisor = {
      #   enable = true;
      # };

      hardware.bolt.enable = true;

      beesd.filesystems = lib.mkIf false {
        root = {
          spec = "UUID=58cb1af5-de48-4aef-b3c3-72ec19237a89";
          hashTableSizeMB = 2048;
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

    # virtualisation.kvmgt = {
    #   enable = true;
    #   device = "0000:00:02.0";
    #   vgpus = {
    #     "i915-GVTg_V5_2" = {
    #       uuid = ["e2ab260f-44a2-4e07-9889-68a1caafb399"];
    #     };
    #   };
    # };

    programs = {
      # adb.enable = true;

      # captive-browser = {
      #   enable = true;
      #   interface = "wlp59s0";
      # };

      # wireshark = {
      #   enable = true;
      #   usbmon.enable = true;
      #   dumpcap.enable = true;
      # };
    };

    # system.includeBuildDependencies = true;
    # system.build.cc1101-driver = pkgs.custom.cc1101-driver.override {kernel = config.boot.kernelPackages.kernel;};

    # hardware = {
    #   deviceTree = {
    #     # enable = true;

    #     overlays = [
    #       {
    #         name = "cc1101";
    #         dtsFile = "${pkgs.custom.cc1101-driver}/lib/overlays/cc1101.dts";
    #       }
    #     ];
    #   };
    # };

    boot = {
      tmp = {
        useTmpfs = true;
      };

      # kernelPackages = pkgs.linuxPackages;

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      # binfmt.emulatedSystems = ["aarch64-linux"];
      # extraModulePackages = [
      # config.system.build.cc1101-driver
      # ];
      # modprobeConfig.enable = true;
      # supportedFilesystems = ["ext2" "ext3" "ext4"];
      kernelParams = [
        "mitigations=off"
        # "efi_pstore.pstore_disable=0"
        # "pstore.backend=efi"
      ];
      #   "i915.enable_gvt=1"
      #   "i915.enable_fbc=0"
      #   "ibt=off"
      #   # "i915.enable_gvt=1"
      #   # "i915.enable_guc=0"
      #   "intel_iommu=on"
      #   "iommu=pt"
      #   # "iommu.passthrough=1"
      # ];
      # blacklists
      # modprobeConfig = {
      #   enable = true;
      # };
      # extraModprobeConfig = ''
      #   options psmouse synaptics_intertouch=1
      # '';
      blacklistedKernelModules = [
        "intel_oc_wdt"
        "iTCO_wdt"
        "nouveau"
      ];
      kernelModules = [
        "coretemp"
        "efi_pstore"
        # "psmouse"
        # "i915"
        # "spi"
        # "sgx"
        # "isgx"
        # "vfio_pci"
        # "vfio"
        # "vfio_iommu_type1"
        "kvm-intel"
        # "watchdog"
        # "usbmon"
      ];

      initrd.kernelModules = [
        "nvidia"
        # "i915"
        "nvidia_modeset"
        # "nvidia_uvm"
        "nvidia_drm"

        # "efi_pstore"

        # "spi"
        # "sgx"
        # "i915"
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
