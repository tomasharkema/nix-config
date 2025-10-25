{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  boot-into-bios = pkgs.writeShellScriptBin "boot-into-bios" ''
    sudo ${pkgs.ipmitool}/bin/ipmitool chassis bootparam set bootflag force_bios
  '';
  workerPort = "9988";
in {
  # imports = with inputs; [
  #   nvidia-vgpu-nixos.nixosModules.host
  # ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVhJ1k25x/1A/zN96p48MGrPJxVboTe17rO9Mcb61qG root@blue-fire";
      };
      secrets = {
        tsnsrv = {
          rekeyFile = ../../../modules/nixos/secrets/tsnsrv.age;
        };
      };
    };

    facter.reportPath = ./facter.json;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";

      boot = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_1C1B0D6AE9B0E410390F2CA6-0:0";

      # btrbk.enable = true;
    };

    traits = {
      server = {
        enable = true;
        headless.enable = true;
        ipmi.enable = true;
      };

      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        # remote-unlock.enable = false;
        network.xgbe.enable = true;
        nvidia = {
          enable = true;
          beta = false;
          open = false;
          grid = {
            enable = false;
          };
        };
      };
    };

    apps = {
      atop = {
        enable = false;
        httpd = false;
      };
      # "bmc-watchdog".enable = true;
      docker.enable = true;
      ollama.enable = true;
    };

    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };

      # xserver.videoDrivers = ["nvidia"];
      watchdogd = {
        enable = true;
      };

      tsnsrv = {
        enable = true;
        defaults.authKeyPath = config.age.secrets.tsnsrv.path;
        services = {
          # nix-cache = {toURL = "http://127.0.0.1:7124";};
          searxng = {toURL = "http://127.0.0.1:8088";};
        };
      };

      das_watchdog.enable = lib.mkForce false;
      lldpd.enable = true;
      remote-builders.server.enable = true;

      beesd.filesystems = lib.mkIf false {
        root = {
          spec = "UUID=91663f26-5426-4a0d-96f0-e507f2cd8196";
          hashTableSizeMB = 1024;
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "2.0"
          ];
        };
      };
      # tcsd.enable = true;
      kmscon.enable = lib.mkForce false;

      prometheus.exporters = {
        ipmi = {
          enable = true;
        };
      };
    };

    # powerManagement.powertop.enable = true;

    networking = {
      # hosts = {
      #   "192.168.0.100" = ["nix-cache.harke.ma"];
      # };
      hostName = "blue-fire";
      hostId = "529fd7aa";

      useDHCP = false;
      networkmanager.enable = true;

      firewall = {
        allowPing = true;

        enable = false;
      };

      # bonds.bond0 = {
      #  interfaces = [
      #    "enp6s0f0"
      #    "enp6s0f1"
      #    "enp6s0f2"
      #    "enp6s0f3"
      #  ];
      #  driverOptions = {
      #    mode = "802.3ad";
      #  };
      # };

      nameservers = ["192.168.0.1"];

      bridges.br0 = {
        interfaces = ["enp6s0"];
      };
      defaultGateway = {
        address = "192.168.0.1";
        interface = "br0";
      };
      interfaces = {
        "eno1" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno2" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno3" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno4" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "enp6s0" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = false;
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.101";
              prefixLength = 24;
            }
          ];
        };
        #"bond0" = {
        #  mtu = 9000;
        #};
      };
    };

    environment.systemPackages = with pkgs; [
      virt-manager
      ipmitool
      boot-into-bios
      openipmi
      freeipmi
      ipmicfg
      ipmiutil
      tremotesf
      icingaweb2
    ];

    # virtualisation.kvmgt = {
    #   enable = lib.mkForce false;
    #   device = "0000:01:00.0";
    #   vgpus = {
    #     "nvidia-256" = {
    #       uuid = [
    #         "e1ab260f-44a2-4e07-9889-68a1caafb399"
    #         "f6a3e668-9f62-11ef-b055-fbc0e7d80867"
    #       ];
    #     };
    #   };
    # };

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      # nvidia-container-toolkit.enable = true;

      nvidia = {
        # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;
        # nvidiaPersistenced = lib.mkForce true;
      };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };

      # kernelPackages = pkgs.linuxPackages_6_12;

      kernelParams = [
        "console=tty1"
        "console=ttyS2,115200"
        # "iomem=relaxed"
        # "mitigations=off"
        #"vfio-pci.ids=10de:1c82"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "pci=nomsi"
      ];

      # binfmt.emulatedSystems = ["aarch64-linux"];

      recovery = {
        sign = true;
        install = true;
      };

      loader = {
        systemd-boot = {
          configurationLimit = 10;

          netbootxyz.enable = true;
        };
        efi.canTouchEfiVariables = true;
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          # "sd_mod"
        ];
        kernelModules = [
          # "pci-me"
          "kvm-intel"

          "uinput"
        ];
      };
      kernelModules = [
        "pci-me"
        "coretemp"
        "kvm-intel"
        "uinput"
        "fuse"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "ipmi_watchdog"
      ];
    };

    services.rpcbind.enable = true;

    systemd = {
      watchdog = {
        device = "/dev/watchdog";
        # runtimeTime = "30s";
        # kexecTime = "5m";
        # rebootTime = "5m";
      };

      mounts = [
        {
          type = "nfs";
          mountConfig = {
            Options = "noatime";
          };
          what = "192.168.1.102:/volume1/tomas";
          where = "/mnt/dione-downloads";
        }
      ];

      automounts = [
        {
          wantedBy = ["multi-user.target"];
          automountConfig = {
            TimeoutIdleSec = "600";
          };
          where = "/mnt/dione-downloads";
        }
      ];

      services = {
        # "serial-getty@ttyS2" = {
        #   wantedBy = ["multi-user.target"];
        # };
      };
    };
  };
}
