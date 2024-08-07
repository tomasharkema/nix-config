{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib; let
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

    trait = {
      server = {
        enable = true;
        headless.enable = true;
      };

      builder = {
        enable = true;
        # hydra.enable = true;
      };
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        nvidia.enable = true;

        # nfs = {
        #   enable = true;
        #   machines = {
        #     silver-star.enable = true;
        #   };
        # };
      };
    };

    # services.cron.systemCronJobs = [
    #   # Reset 5-minute watchdog timer every minute
    #   "* * * * * ${pkgs.ipmitool}/bin/ipmitool raw 0x30 0x97 1 5"
    # ];

    apps = {
      # attic-server.enable = true;
      ntopng.enable = true;
      atop = {
        enable = true;
        httpd = true;
      };
      "bmc-watchdog".enable = true;
    };

    gui = {
      icewm.enable = true;
      # desktop.enable = true;
    };

    services = {
      hound = {
        enable = true;
        config = builtins.toJSON {
          max-concurrent-indexers = 2;
          repos = {
            nixpkgs = {
              url = "https://www.github.com/NixOS/nixpkgs.git";
              vcs-config = {
                ref = "nixos-24.05";
              };
            };
          };
        };
      };

      watchdogd = {enable = true;};

      das_watchdog.enable = mkForce false;

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
      kmscon.enable = true;

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

    apps = {
      podman.enable = true;
      buildbot.worker.enable = true;
    };

    systemd = {
      watchdog = {
        device = "/dev/watchdog";
        runtimeTime = "5m";
        kexecTime = "5m";
        rebootTime = "5m";
      };
      services = {
        buildbot-worker.serviceConfig = {
          MemoryHigh = "5%";
          MemoryMax = "10%";
          Nice = 10;
        };
      };
    };

    # services = {
    # podman.enable = true;
    # freeipa.replica.enable = true;
    # };

    nix.settings.allowed-uris = [
      "https://"
      "git+https://"
      "github:"
      "github:NixOS/"
      "github:nixos/"
      "github:hercules-ci/"
      "github:numtide/"
      "github:cachix/"
      "github:nix-community/"
      "github:snowfallorg/"
      "github:edolstra/"
      "github:tomasharkema/"
      "github:snowfallorg/"
      "github:gytis-ivaskevicius/"
      "github:ryantm/"
    ];

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
      networkmanager.enable = false;

      interfaces = {
        "eno1" = {
          useDHCP = true;
          wakeOnLan.enable = true;
        };
        "br0" = {useDHCP = true;};
        "bond0" = {
          # useDHCP = true;
          # wakeOnLan.enable = true;
        };
        #   "eno2" = {
        #     useDHCP = true;
        #     wakeOnLan.enable = true;
        #   };
        #   "eno3" = {
        #     useDHCP = true;
        #     wakeOnLan.enable = true;
        #   };
        #   "eno4" = {
        #     useDHCP = true;
        #     wakeOnLan.enable = true;
        #   };
      };
    };

    services.hypervisor = {
      enable = true;
      # bridgeInterfaces = [ "eno1" ];
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrant
      ipmitool
      boot-into-bios
      openipmi
      freeipmi
      ipmicfg
      ipmiutil
      tremotesf
      # icingaweb2
    ];

    networking.firewall.allowedTCPPorts = [2049];

    # services.factorio.enable = true;

    fileSystems = {
      # "/export/media" = {
      #   device = "/media";
      #   options = ["bind"];
      # };
      #   "/mnt/unraid/domains" = {
      #     device = "192.168.0.100:/mnt/user/domains";
      #     fsType = "nfs";
      #   };
      #   "/mnt/unraid/appdata" = {
      #     device = "192.168.0.100:/mnt/user/appdata";
      #     fsType = "nfs";
      #   };
      #   "/mnt/unraid/appdata_ssd" = {
      #     device = "192.168.0.100:/mnt/user/appdata_ssd";
      #     fsType = "nfs";
      #   };
      #   "/mnt/unraid/appdata_disk" = {
      #     device = "192.168.0.100:/mnt/user/appdata_disk";
      #     fsType = "nfs";
      #   };
      #   # "/mnt/dione" = {
      #   #   device = "192.168.178.3:/volume1/homes";
      #   #   fsType = "nfs";
      #   # };
    };

    systemd.network = {
      enable = true;
      netdevs = {
        "10-bond0" = {
          netdevConfig = {
            Kind = "bond";
            Name = "bond0";
          };
          bondConfig = {
            Mode = "802.3ad";
            TransmitHashPolicy = "layer3+4";
          };
        };
        "20-br0" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "br0";
          };
        };
      };
      networks = {
        "20-eno1" = {
          matchConfig.Name = "eno1";
        };

        "30-enp6s0f0" = {
          matchConfig.Name = "enp6s0f0";
          networkConfig.Bond = "bond0";
        };
        "30-enp6s0f1" = {
          matchConfig.Name = "enp6s0f1";
          networkConfig.Bond = "bond0";
        };
        "30-enp6s0f2" = {
          matchConfig.Name = "enp6s0f2";
          networkConfig.Bond = "bond0";
        };
        "30-enp6s0f3" = {
          matchConfig.Name = "enp6s0f3";
          networkConfig.Bond = "bond0";
        };
        "40-bond0" = {
          matchConfig.Name = "bond0";
          networkConfig.Bridge = "br0";
          linkConfig.RequiredForOnline = "enslaved";
        };
        "41-br0" = {
          matchConfig.Name = "br0";
          bridgeConfig = {};
          linkConfig = {
            RequiredForOnline = "carrier";
          };
          networkConfig = {
            DHCP = "yes";
            LinkLocalAddressing = "no";
          };
        };
      };
    };

    hardware.nvidia.vgpu = {
      enable = true; # Enable NVIDIA KVM vGPU + GRID driver
      unlock.enable = true; # Unlock vGPU functionality on consumer cards using DualCoder/vgpu_unlock project.
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
        "console=tty0"
        "console=ttyS2,115200n8"
        "mitigations=off"
      ];
      blacklistedKernelModules = lib.mkDefault ["nouveau"];

      binfmt.emulatedSystems = ["aarch64-linux"];
      recovery = {
        sign = false;
        install = false;
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
          "kvm-intel"
          "uinput"
          #          "tpm_rng"
          "ipmi_ssif"
          # "acpi_ipmi"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
        ];
      };
      kernelModules = [
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
      # extraModulePackages = [pkgs.freeipmi];
      systemd.services."serial-getty@ttyS2".wantedBy = ["multi-user.target"];
    };

    # virtualisation = {
    # oci-containers.containers = {
    # social-dl = {
    #   image = "docker.io/tomasharkema7/social-dl";
    #   autoStart = true;
    #   # ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
    #   # hostname = "ipa.harkema.io";
    #   # extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0"];
    #   # cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
    #   # volumes = [
    #   #   "/var/lib/freeipa:/data:Z"
    #   # ];
    # };
    # };
    # };
  };
}
