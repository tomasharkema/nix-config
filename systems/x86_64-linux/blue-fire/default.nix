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
    };

    facter.reportPath = ./facter.json;

    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-persistenced"
      ];

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";
      # btrbk.enable = true;
    };

    traits = {
      server = {
        enable = true;
        headless.enable = true;
      };

      builder.enable = true;

      hardware = {
        tpm.enable = true;
        secure-boot.enable = false;
        # remote-unlock.enable = false;
        network.xgbe.enable = true;
        nvidia = {
          enable = true;
          beta = false;
          open = false;
          grid = {enable = true;};
        };
      };
    };

    apps = {
      # attic-server.enable = true;

      atop = {
        enable = false;
        httpd = false;
      };
      "bmc-watchdog".enable = true;
      podman.enable = lib.mkForce true;
      ollama.enable = true;
      # zabbix.server.enable = true;
      # atticd.enable = true;
    };

    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };
      plex = {
        enable = true;

        dataDir = "/srv/plex/library";
        accelerationDevices = ["*"];
      };
      xserver.videoDrivers = ["nvidia"];
      watchdogd = {
        enable = true;
      };

      das_watchdog.enable = lib.mkForce false;

      remote-builders.server.enable = true;

      beesd.filesystems = {
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
      # icingaweb2 = {
      #   enable = true;
      #   virtualHost = "mon.blue-fire.harkema.intra";
      #   modules.setup.enable = true;
      #   authentications = {
      #     icingaweb = {
      #       backend = "db";
      #       resource = "icingaweb_db";
      #     };
      #   };
      # };

      # ha.initialMaster = true;
      # command-center = {
      #   enableBot = true;
      # };

      # tcsd.enable = true;
      kmscon.enable = lib.mkForce false;

      prometheus.exporters = {
        ipmi = {
          enable = true;
        };
      };
    };

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

        allowedTCPPorts = [
          7070
          111
          2049
          4000
          4001
          4002
          20048
        ];
        allowedUDPPorts = [
          111
          2049
          4000
          4001
          4002
          20048
        ];
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
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrantservices
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

    virtualisation.kvmgt = {
      enable = true;
      device = "0000:01:00.0";
      vgpus = {
        "nvidia-256" = {
          uuid = [
            "e1ab260f-44a2-4e07-9889-68a1caafb399"
            "f6a3e668-9f62-11ef-b055-fbc0e7d80867"
          ];
        };
      };
    };

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia-container-toolkit.enable = true;

      nvidia = {
        # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;
        # nvidiaPersistenced = lib.mkForce true;

        # nix-prefetch-url --type sha256 https://us.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
        # package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.vgpu_17_3;

        vgpu.patcher = {
          #enable = true;
          options = {
            # doNotForceGPLLicense = false;
            remapP40ProfilesToV100D = lib.mkForce false;
          };
          #copyVGPUProfiles = {
          #  "1E87:0000" = "1E30:12BA";
          #  "1380:0000" = "13BD:1160";
          #};
          #enablePatcherCmd = true;
        };
      };
    };

    # virtualisation.oci-containers.containers.fastapi-dls = {
    #   ports = lib.mkForce ["7070:443"];
    # };

    boot = {
      tmp = {
        useTmpfs = true;
      };

      kernelPackages = pkgs.linuxPackages_6_11;

      kernelParams = [
        "console=tty1"
        "console=ttyS2,115200"

        # "mitigations=off"i
        #"vfio-pci.ids=10de:1c82"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "pci=nomsi"
      ];

      binfmt.emulatedSystems = ["aarch64-linux"];

      recovery = {
        sign = true;
        install = true;
      };

      loader = {
        systemd-boot = {
          enable = true;
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
        #       "tpm_rng"
        "ipmi_ssif"
        # "acpi_ipmi"
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
        runtimeTime = "5m";
        kexecTime = "5m";
        rebootTime = "5m";
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
