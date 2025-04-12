{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMESuHxB6/b4HP0S/Ad76XIR5s473hvPXFN8uzjhFZBp root@voltron";
      };
    };

    facter = {
      reportPath = ./facter.json;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes.enable = true;
      # btrbk.enable = true;
      snapper.enable = true; # false;
      swap = {
        size = "32G";
        resume.enable = true;
      };
    };

    # programs.gnupg.agent = {
    #   enable = true;
    # };

    systemd = {
      services.usbmuxd.path = [pkgs.libusb1];
      # network.links."81-pi" = {
      #   matchConfig = {
      #     Property = [
      #       "ID_MODEL_ID=a4aa"
      #       "ID_VENDOR_ID=0525"
      #     ];
      #    Driver = "cdc_ether";
      #   };
      #   linkConfig.Name = "pi0";
      # networkConfig.DHCP = true;
      # };
    };

    environment = {
      systemPackages = with pkgs; [
        gt
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
        # handbrake

        keybase-gui
        # calibre
        glxinfo
        inxi
        pwvucontrol

        piper
        libratbag
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
      hyrland.wluma = {
        enable = true;
        backlightDevice = "/sys/class/backlight/intel_backlight";
      };
    };

    # chaotic.mesa-git.enable = true;

    hardware = {
      mcelog.enable = true;
      usb-modeswitch.enable = true;

      nvidia = {
        # forceFullCompositionPipeline = true;

        prime = {
          sync.enable = true;
          # offload.enable = true;
          # offload.enableOffloadCmd = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:02:0:0";
        };

        powerManagement = {
          # enable = true;
          # finegrained = true;
        };
      };

      # fancontrol.enable = true;
    };

    # virtualisation.waydroid.enable = true;

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
        enable = false; # true; # wlp4s0; # false;
        allowPing = true;
        # trustedInterfaces = ["virbr0" "virbr1" "vnet0"];
      };
    };

    services = {
      #  kmscon.enable = true;
      ratbagd.enable = true;
      # comin.enable = false;
      abrt.enable = true;
      # remote-builders.client.enable = true;
      usbmuxd.enable = true;
      power-profiles-daemon.enable = lib.mkForce true;

      clamav.daemon.settings.MaxThreads = 4;

      udev = {
        enable = true;
        #extraRules = ''
        #  `SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="aa:bb:cc:dd:ee:ff", NAME="net1`
        #'';
        packages = with pkgs; [
          heimdall-gui
          libusb1

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

      hardware.lcd.server = lib.mkIf false {
        enable = true;
        #extraConfig=''
        #  [text]
        #  Size=128x32
        #'';
        extraConfig = ''
          [hd44780]
          ConnectionType=i2c
          Port=0x3C
          Device=/dev/i2c-8
          Speed=0
          Keypad=no
          Size=128x64
          CharMap=hd44780_default
        '';
      };
      hardware.bolt.enable = true;
      beesd.filesystems = lib.mkIf false {
        root = {
          spec = "UUID=58cb1af5-de48-4aef-b3c3-72ec19237a89";
          hashTableSizeMB = 4096;
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
        "i915-GVTg_V5_2" = {
          uuid = ["e2ab260f-44a2-4e07-9889-68a1caafb399"];
        };
      };
    };

    programs = {
      adb.enable = true;
      # captive-browser = {
      #   enable = true;
      #   interface = "wlp4s0";
      # };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      # kernelPackages = pkgs.linuxPackages_latest;
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      binfmt.emulatedSystems = ["aarch64-linux"];

      # modprobeConfig.enable = true;
      supportedFilesystems = ["ext2" "ext3" "ext4"];
      kernelParams = [
        "i915.enable_gvt=1"
        "i915.enable_fbc=0"

        # "i915.enable_gvt=1"
        # "i915.enable_guc=0"
        "intel_iommu=on"
        "iommu=pt"
        # "iommu.passthrough=1"
      ];
      blacklistedKernelModules = [
        "nouveau"
      ];
      # modprobeConfig = {
      #   enable = true;
      # };
      # extraModprobeConfig = ''
      #   options psmouse synaptics_intertouch=1
      # '';
      kernelModules = [
        # "psmouse"
        "i915"
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
        # "kvm-intel"
      ];
    };
  };
}
