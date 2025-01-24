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
  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMfjVCxpx87jpHR6CAUoZsEvwZOSTKyUmYDl3vXIUeu root@silver-star";
      };
    };

    facter.reportPath = ./facter.json;

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      second = "/dev/nvme1n1";
      boot = "/dev/sda";
      # btrbk.enable = true;
    };

    traits = {
      server = {
        enable = true;
        headless.enable = true;
      };

      builder.enable = true;

      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;

        nvidia = {
          enable = true;
          open = false;
          grid = false;
        };
      };
    };

    apps = {
      netdata.server.enable = true;
      ntopng.enable = true;
      mailrise.enable = true;
      atop = {
        enable = true;
        httpd = false; # true;
      };
      # "bmc-watchdog".enable = true;
      podman.enable = true;
      docker.enable = false;
      # zabbix.server.enable = true;
      atticd.enable = true;
    };

    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };
      # mosh.enable = true;
      xserver.videoDrivers = ["nvidia"];

      "nix-private-cache".enable = true;

      tcsd.enable = true;

      throttled.enable = lib.mkForce false;

      tailscale.tsnsrv = {
        enable = true;
        vhosts = {
          nix-cache = {port = 7124;};
        };
      };

      usbguard.enable = false;

      watchdogd = {
        enable = true;
      };

      das_watchdog.enable = lib.mkForce false;

      remote-builders.server.enable = true;

      beesd.filesystems = {
        root = {
          spec = "UUID=948d8479-177a-4204-a6a8-5d2013f3dc88";
          hashTableSizeMB = 2048;
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
        runtimeTime = "30s";
        kexecTime = "5m";
        rebootTime = "5m";
      };

      # services."docker-compose@atuin".wantedBy = ["multi-user.target"];
    };

    # services = {
    # podman.enable = true;
    # freeipa.replica.enable = true;
    # };

    networking = {
      hostName = "silver-star";

      firewall = {
        allowPing = true;
      };

      bridges.br0 = {
        interfaces = ["eno1"];
      };

      defaultGateway = {
        address = "192.168.0.1";
        interface = "br0";
      };

      interfaces = {
        "enp5s0" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno1" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno2" = {
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno3" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno4" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = lib.mkDefault false;
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.100";
              prefixLength = 24;
            }
          ];
        };
      };

      # useDHCP = false;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrant
      docker-compose
      simpleTpmPk11
      libsmbios
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
    #   enable = true;

    #   # device = "0000:42:00.0";
    #   device = "0000:05:00.0";
    #   vgpus = {
    #     "nvidia-36" = {
    #       uuid = [
    #         "e1ab260f-44a2-4e07-9889-68a1caafb399"
    #         "f6a3e668-9f62-11ef-b055-fbc0e7d80867"
    #       ];
    #     };
    #   };
    # };

    # fileSystems."/etc" = {
    #   device = "none";
    #   fsType = "tmpfs";
    #   options = ["defaults" "size=25%" "mode=755"];
    # };

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia-container-toolkit.enable = true;

      nvidia = {
        # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce true;

        # nix-prefetch-url --type sha256 https://us.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
      };
    };

    virtualisation = {
      oci-containers.containers = {
        # seq = {
        #   # docker run --name seq -d --restart unless-stopped -e ACCEPT_EULA=Y -p 5341:80 datalust/seq:latest

        #   image = "datalust/seq:latest";

        #   autoStart = true;

        #   environment = {
        #     ACCEPT_EULA = "Y";
        #   };

        #   volumes = [
        #     "/srv/seq/data:/data"
        #     # "/var/lib/netboot/config:/config"
        #     # "/var/lib/netboot/assets:/assets"
        #   ];

        #   ports = [
        #     "5341:5341"
        #     "514:514/udp"
        #     "5380:80"
        #   ];
        # };

        # seq-input-syslog = {
        #   # docker run --name seq -d --restart unless-stopped -e ACCEPT_EULA=Y -p 5341:80 datalust/seq:latest

        #   image = "datalust/seq-input-syslog:latest";

        #   autoStart = true;

        #   environment = {
        #     SEQ_ADDRESS = "http://127.0.0.1:5341";
        #   };

        #   ports = [
        #     "514:514/udp"
        #   ];
        # };

        netbootxyz = {
          image = "ghcr.io/linuxserver/netbootxyz";

          autoStart = true;

          volumes = [
            "/var/lib/netboot/config:/config"
            "/var/lib/netboot/assets:/assets"
          ];

          ports = [
            "3001:3000"
            "69:69/udp"
            "8083:80"
          ];
        };

        openmanage = {
          image = "docker.io/teumaauss/srvadmin";

          volumes = let
            kernelVideo = config.boot.kernelPackages.kernel.version;
          in [
            "/run/current-system/sw/lib/modules/${kernelVideo}:/lib/modules/${kernelVideo}"
            "/usr/libexec/dell_dup:/usr/libexec/dell_dup:Z"
          ];

          extraOptions = [
            "--privileged"
            "--net=host"
            "--device=/dev/mem"
            "--systemd=always"
          ];
          autoStart = true;
        };

        fastapi-dls = {
          image = "collinwebdesigns/fastapi-dls";

          volumes = [
            "/var/lib/fastapi-dls/cert:/app/cert:rw"
            "/var/lib/fastapi-dls/dls-db:/app/database"
          ];
          # Set environment variables
          environment = {
            TZ = "Europa/Amsterdam";
            DLS_URL = config.networking.hostName;
            DLS_PORT = "7070";
            LEASE_EXPIRE_DAYS = "90";
            DATABASE = "sqlite:////app/database/db.sqlite";
            DEBUG = "true";
          };
          extraOptions = [
          ];

          ports = ["7070:443"];

          autoStart = true;
        };
      };
    };

    # systemd.services = {
    #   "tsnsrv-nix-cache" = {
    #     environment = {
    #       TS_STATE_DIR = "/var/lib/tsnsrv";
    #     };
    #     script = "${pkgs.custom.tsnsrv}/bin/tsnsrv -name nix-cache http://127.0.0.1:7124";
    #     wantedBy = ["multi-user.target"];
    #   };

    #   #"docker-compose@atuin" = {
    #   #  wantedBy = [ "multi-user.target" ];
    #   #};
    # };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelPackages = pkgs.linuxPackages_6_12;
      kernelParams = [
        "console=tty1"
        "console=ttyS0,115200n8"
        "mitigations=off"
        "intremap=no_x2apic_optout"
        "nox2apic"

        "intel_iommu=on"
        "iommu=pt"
        "video=efifb:off,vesafb:off"

        #"vfio-pci.ids=10de:1380,10de:0fbc"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "iomem=relaxed"
        # "pci=nomsi"
      ];

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
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
          "dell_rbu"
          "dcdbas"
          # "sd_mod"
        ];
        kernelModules = [
          "dcdbas"
          "dell_rbu"
          # "pci-me"
          "kvm-intel"

          "uinput"
          #          "tpm_rng"
          "ipmi_ssif"
          "ipmi_ipmb"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
          "ipmi_watchdog"
          "acpi_ipmi"
        ];
      };
      kernelModules = [
        "pci-me"
        "coretemp"
        "kvm-intel"
        "uinput"
        "fuse"
        "ipmi_ipmb"
        #       "tpm_rng"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "ipmi_watchdog"
      ];

      systemd.services."serial-getty@ttyS0" = {
        wantedBy = ["multi-user.target"];
      };
      systemd.services."docker-compose@atuin" = {
        wantedBy = ["multi-user.target"];
      };

      systemd.services."docker-compose@grafana" = {
        wantedBy = ["multi-user.target"];
      };

      systemd.services."docker-compose@zabbix" = {
        wantedBy = ["multi-user.target"];
      };
      # systemd.services."serial-getty@ttyS2" = {
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
      # wantedBy = ["multi-user.target"];
      #   #environment.TERM = "vt102";
      # };
    };
  };
}
