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
  imports = with inputs; [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # nixos-hardware.nixosModules.supermicro-x10sll-f
    nixos-nvidia-vgpu.nixosModules.nvidia-vgpu
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVhJ1k25x/1A/zN96p48MGrPJxVboTe17rO9Mcb61qG root@blue-fire";
      };
    };

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
        secure-boot.enable = true;
        remote-unlock.enable = true;
        nvidia = {
          # enable = true;
          # beta = false;
          # open = false;
        };
        # nfs = {
        #   enable = true;
        #   machines = {
        #     silver-star.enable = true;
        #   };
        # };
      };
    };

    apps = {
      # attic-server.enable = true;
      ntopng.enable = true;
      atop = {
        enable = true;
        httpd = true;
      };
      "bmc-watchdog".enable = true;
      podman.enable = true;
    };

    gui = {
      icewm.enable = true;
      # desktop.enable = true;
      rdp = {
        enable = true;
        legacy = true;
      };
    };

    services = {
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
      # nfs = {
      #   server = {
      #     enable = true;
      #     exports = ''
      #       /export/media        *(rw,fsid=0,no_subtree_check)
      #     '';
      #   };
      # };
    };

    systemd = {
      watchdog = {
        device = "/dev/watchdog";
        runtimeTime = "5m";
        kexecTime = "5m";
        rebootTime = "5m";
      };
    };

    # services = {
    # podman.enable = true;
    # freeipa.replica.enable = true;
    # };

    # nix.settings.allowed-uris = [
    #   "https://"
    #   "git+https://"
    #   "github:"
    #   "github:NixOS/"
    #   "github:nixos/"
    #   "github:hercules-ci/"
    #   "github:numtide/"
    #   "github:cachix/"
    #   "github:nix-community/"
    #   "github:snowfallorg/"
    #   "github:edolstra/"
    #   "github:tomasharkema/"
    #   "github:snowfallorg/"
    #   "github:gytis-ivaskevicius/"
    #   "github:ryantm/"
    # ];

    networking = {
      hosts = {
        "192.168.0.100" = ["nix-cache.harke.ma"];
      };
      hostName = "blue-fire";
      hostId = "529fd7aa";

      firewall = {
        enable = true;
        allowPing = true;
      };

      # useDHCP = false;
      networkmanager.enable = true;

      firewall.allowedTCPPorts = [
        2049
        7070
      ];
      bonds.bond0 = {
        interfaces = [
          "enp6s0f0"
          "enp6s0f1"
          "enp6s0f2"
          "enp6s0f3"
        ];
        driverOptions = {
          mode = "802.3ad";
        };
      };

      bridges.br0 = {
        interfaces = ["bond0"];
      };

      interfaces = {
        "enp6s0f0" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "enp6s0f1" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "enp6s0f2" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "enp6s0f3" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = lib.mkDefault true;
        };
        "bond0" = {
          mtu = 9000;
        };
      };
    };

    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };

      xserver.videoDrivers = ["nvidia"];
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrant
      virt-manager
      ipmitool
      boot-into-bios
      openipmi
      freeipmi
      ipmicfg
      ipmiutil
      tremotesf
      # icingaweb2
    ];

    # virtualisation.kvmgt = {
    # enable = true;
    # device = "0000:01:00.0";
    # vgpus = {
    #   "nvidia-37" = {
    #    # for windows!!
    #    uuid = ["e1ab260f-44a2-4e07-9889-68a1caafb399"];
    # };
    #  };
    # };

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia-container-toolkit.enable = true;

      nvidia = {
        modesetting.enable = true;
        # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;

        vgpu = {
          enable = true;
          pinKernel = true;

          vgpu_driver_src.sha256 = "02xsgav0v5xrzbjxwx249448cj6g46gav3nlrysjjzh3az676w5r";

          copyVGPUProfiles = {
            "1380:0000" = "13BD:1160";
          };

          fastapi-dls = {
            enable = true;
            docker-directory = "/var/lib/fastapi";
            local_ipv4 = "192.168.0.101";
            timezone = "Europe/Amsterdam";
          };
        };
      };
    };

    # virtualisation.oci-containers.containers.fastapi-dls = {
    #   ports = lib.mkForce [ "7070:443" ];
    # };

    # services.udev.extraRules = ''
    #   SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    # '';

    boot = {
      tmp = {
        useTmpfs = true;
      };
      kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
        "console=tty0"
        "console=ttyS2,115200n8"
        # "mitigations=off"
        #"vfio-pci.ids=10de:1380,10de:0fbc"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        "blacklist=nouveau"
        # "pci=nomsi"
      ];
      blacklistedKernelModules = ["nouveau"];

      binfmt.emulatedSystems = ["aarch64-linux"];
      recovery = {
        sign = true;
        install = true;
      };
      loader = {
        systemd-boot = {
          # enable = true;
          configurationLimit = 10;
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
          #          "tpm_rng"
          "ipmi_ssif"
          # "acpi_ipmi"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          "vfio_virqfd"

          # "nvidia"
          # "nvidia_modeset"
          # "nvidia_uvm"
          # "nvidia_drm"
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

        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # "vfio_virqfd"

        # "nvidia"
        # "nvidia_modeset"
        # "nvidia_uvm"
        # "nvidia_drm"
      ];

      extraModulePackages = [config.boot.kernelPackages.sysdig];

      systemd.services."serial-getty@ttyS2" = {
        #   overrideStrategy = "asDropin";
        #   serviceConfig = let
        #     tmux = pkgs.writeShellScript "tmux.sh" ''
        #       ${pkgs.tmux}/bin/tmux kill-session -t start 2> /dev/null
        #       ${pkgs.tmux}/bin/tmux new-session -s start
        #     '';
        #   in {
        #     TTYVTDisallocate = "no";
        #     #ExecStart = ["" "-${tmux}"];
        #     #StandardInput = "tty";
        #     #StandardOutput = "tty";
        #   };
        wantedBy = ["multi-user.target"];
        #   #environment.TERM = "vt102";
      };
    };
  };
}
