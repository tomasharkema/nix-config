{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./trmnl.nix
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMfjVCxpx87jpHR6CAUoZsEvwZOSTKyUmYDl3vXIUeu root@silver-star";
      };
      secrets = {
        tsnsrv.rekeyFile = ../../../modules/nixos/secrets/tsnsrv.age;
        cloudflared.rekeyFile = ./cloudflared.age;
        grafana-ntfy.rekeyFile = ./grafana-ntfy.age;
        #        "healthchecks" = {
        #         rekeyFile = ./healthchecks.age;
        #        group = "healthchecks";
        #       owner = "healthchecks";
        #    };
        firefox. rekeyFile = ./firefox.age;
      };
    };

    facter = {
      reportPath = ./facter.json;
      # detected.graphics.enable = false;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7PJNJ0Y411286E_1-part1";
      boot = "/dev/disk/by-id/usb-DELL_IDSDM_012345678901-0:0";
      snapper.enable = false;
      # btrbk.enable = true;
      swap.enable = false;
    };

    zramSwap.enable = false;

    traits = {
      server = {
        enable = true;
        headless.enable = true;
        ipmi.enable = true;
      };
      github-runner.enable = true;

      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
        network.xgbe.enable = true;
        nvidia = {
          enable = true;
          open = false;
          # grid = {
          #   legacy = false;
          # };
        };
      };
    };

    apps = {
      netdata.server.enable = true;
      netbox.enable = true;
      clamav.onacc.enable = false;
      mailrise.enable = true;
      hass.enable = true;
      atop = {
        enable = true;
        httpd = false; # true;
      };
      # "bmc-watchdog".enable = true;
      docker.enable = true;
      zabbix.server.enable = true;
      prometheus.server.enable = true;
    };

    fileSystems = {
      "/export/netboot" = {
        device = "/mnt/netboot";
        options = ["bind"];
      };
    };
    # system.includeBuildDependencies = true;

    programs.nh = {
      clean.enable = true;
      clean.extraArgs = "--keep-since 3M";
    };

    virtualisation = {
      incus = {
        enable = true;
        # socketActivation = true;
        ui.enable = true;
      };
    };
    users.groups = {"incus-admin".members = ["tomas"];};

    services = {
      hypervisor = {
        enable = true;
        iommu.enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };
      # mosh.enable = true;
      # xserver.videoDrivers = ["nvidia"];

      # "nix-private-cache".enable = true;
      graylog = {
        enable = true;
        package = pkgs.graylog-6_1;
        rootPasswordSha2 = "54138f711f6e6c523b61a060b224beb78697a48211613395ffdc4ba60c0a3fc5";
        passwordSecret = "oW83oXQNzoWk8gMBqMYnBtVhGMrzm8ddM9xmFBMInjPuocGuA8YWe4cfDmPsQqf7o0v41NekCF37W4tbRPnZpOkqbWmqipS5";
        extraConfig = ''
          http_external_uri = https://graylog.ling-lizard.ts.net/
        '';
        elasticsearchHosts = ["http://127.0.0.1:9200"];
      };

      mongodb = {
        enable = true;
        package = pkgs.mongodb-7_0;
      };
      opensearch = {
        enable = true;
        settings = {
          "cluster.name" = "ep-cluster";
        };
      };

      sonarr.enable = true;
      jackett.enable = true;

      # transmission = {
      #   enable = true;
      #   openRPCPort = true;
      #   #downloadDirPermissions = "770";
      #   openPeerPorts = true;
      #   openFirewall = true;
      #   settings = {
      #     download-dir = "/exports/downloads";
      #     rpc-bind-address = "0.0.0.0";
      #     rpc-whitelist = "127.0.0.1,192.168.*.*,100.*.*.*";
      #   };
      # };

      immich = {
        enable = true;
        host = "0.0.0.0";
        openFirewall = true;

        machine-learning = {
          environment = {
            IMMICH_HOST = lib.mkForce "0.0.0.0";
          };
        };
      };

      irqbalance.enable = true;

      nfs = {
        server = {
          enable = true;
          exports = ''
            /export/netboot        *(rw,fsid=0,no_subtree_check)
          '';
        };
      };

      uptime-kuma = {
        enable = true;
        settings = {
          HOST = "0.0.0.0";
          PORT = "4000";
        };
      };

      # healthchecks = {
      #   enable = true;
      #   listenAddress = "0.0.0.0";

      #   # notificationSender = "tomas+hydra@harkema.io";
      #   # useSubstitutes = true;
      #   # smtpHost = "smtp-relay.gmail.com";

      #   settings = {
      #     SECRET_KEY_FILE = config.age.secrets.healthchecks.path;

      #     EMAIL_HOST = "localhost";
      #     EMAIL_PORT = "8025";
      #     EMAIL_HOST_USER = "tomas@harkema.io";
      #     # # EMAIL_HOST_PASSWORD=mypassword
      #     EMAIL_USE_SSL = "False";
      #     EMAIL_USE_TLS = "False";
      #   };
      # };

      mosquitto = {
        enable = true;
        listeners = [
          {
            acl = ["pattern readwrite #"];
            omitPasswordAuth = true;
            settings.allow_anonymous = true;
          }
        ];
      };

      lldpd.enable = true;

      usbguard.enable = lib.mkForce false;
      # tcsd.enable = true;

      throttled.enable = lib.mkForce false;

      plex = {
        enable = true;

        dataDir = "/srv/plex/library";
        accelerationDevices = ["*"];
      };

      harmonia = {
        enable = true;
        signKeyPaths = [config.age.secrets."nix-sign-private".path];
        settings = {
          bind = "[::]:7124";
        };
      };
      #grafana-to-ntfy = {
      #  enable = true;
      #  settings = {
      #    ntfyUrl = "https://ntfy.sh/grafana-abcdefg";
      #    #ntfyBAuthUser = null;
      #    ntfyBAuthPass = "/dev/null";
      #    bauthUser = "ntfy";
      #    bauthPass = config.age.secrets.grafana-ntfy.path;
      #  };
      #};

      # pgadmin = {
      #   enable = true;
      #   openFirewall = true;
      #   initialEmail = "tomas@harkema.io";
      #   initialPasswordFile = pkgs.writeText "ps" "testtest";
      # };

      tsnsrv = {
        enable = true;
        defaults.authKeyPath = config.age.secrets.tsnsrv.path;
        services = {
          nix-cache = {toURL = "http://127.0.0.1:7124";};
          # searxng = {toURL = "http://127.0.0.1:8088";};
          # glitchtip = {
          #   toURL = "http://127.0.0.1:${builtins.toString config.services.glitchtip.port}";
          # };
          grafana = {toURL = "http://127.0.0.1:3000";};
          healthchecks = {toURL = "http://127.0.0.1:8000";};
          netbox = {toURL = "http://127.0.0.1:8002";};
          netdata = {toURL = "http://127.0.0.1:19999";};
          esphome = {toURL = "http://127.0.0.1:6052";};
          atuin = {toURL = "http://127.0.0.1:8888";};
          trmnl = {toURL = "http://127.0.0.1:2300";};
          immich-ml = {toURL = "http://127.0.0.1:3003";};
          incus = {
            toURL = "https://127.0.0.1:8443";
            insecureHTTPS = true;
          };
          graylog = {toURL = "http://127.0.0.1:9000";};
        };
      };

      watchdogd = {
        enable = true;
      };

      das_watchdog.enable = lib.mkForce false;

      remote-builders.server.enable = true;

      beesd.filesystems = lib.mkIf false {
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

      # glitchtip = {
      #   enable = true;
      #   port = 8923;
      #   # listenAddress = "0.0.0.0";

      #   settings = {
      #     GLITCHTIP_DOMAIN = "https://glitchtip.ling-lizard.ts.net";
      #   };
      # };
      # mysql = {
      #   enable = true;
      #   package = pkgs.mariadb;
      # };

      # firefox-syncserver = {
      #   enable = true;
      #   secrets = config.age.secrets.firefox.path;

      #   database = {
      #     createLocally = true;
      #     user = "firefox-syncserver";
      #     name = "firefox_syncserver";
      #   };

      #   singleNode = {
      #     enable = true;
      #     hostname = "silver-star.ling-lizard.ts.net";
      #     url = "http://silver-star.ling-lizard.ts.net:5000";
      #   };
      # };

      # pocket-id = {
      #   enable = true;
      #   settings = {
      #     APP_URL = "https://id.harke.ma";
      #     TRUST_PROXY = true;
      #   };
      # };

      cloudflared = {
        enable = true;
        tunnels = {
          "69bc7708-5c7b-422d-b283-9199354f431f" = {
            credentialsFile = config.age.secrets.cloudflared.path;
            default = "http_status:404";
            ingress = {
              #       "id.harke.ma" = {
              #         service = "http://localhost:1411";
              #       };
            };
          };
        };
      };

      kmscon.enable = lib.mkForce false;

      netbootxyz.enable = true;
    };

    networking = {
      hostName = "silver-star";

      firewall = {
        enable = false;
        allowPing = true;
        allowedTCPPorts = [1883 32400 8443];
        allowedUDPPorts = [1883 32400 8443];
      };

      # nftables.enable = false;

      bridges.br0 = {
        interfaces = ["eno1"];
      };

      defaultGateway = {
        address = "192.168.0.1";
        interface = "br0";
      };

      vlans = {
        "vlan69" = {
          id = 69;
          interface = "eno1";
        };
        "vlan66" = {
          id = 66;
          interface = "eno1";
        };
      };

      interfaces = {
        "eno1" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno2" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno3" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno4" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = false;
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.100";
              prefixLength = 24;
            }
          ];
        };
        "vlan69" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "vlan66" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
      };

      useDHCP = false;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      docker-compose
      simpleTpmPk11
      libsmbios
      virt-manager
      ipmitool
      openipmi
      freeipmi
      ipmicfg
      ipmiutil
      tremotesf
      # custom.racadm
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

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;
      #
      # nvidia-container-toolkit.enable = true;
      #
      nvidia = {
        nvidiaSettings = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce true;
        # open = false;
      };
    };

    virtualisation = {
      oci-containers.containers = {
        openmanage = {
          image = "teumaauss/srvadmin:latest";

          volumes = let
            kernelVersion = config.boot.kernelPackages.kernel.modDirVersion;
          in [
            "/run/current-system/sw/lib/modules/${kernelVersion}:/lib/modules/${kernelVersion}:ro"
            "/sys:/sys:ro"
            "/srv/openmanage/shared:/data"
            "/nix/store:/nix/store:ro"
            "/etc/os-release:/etc/os-release:ro"
            "/usr/libexec/dell_dup:/usr/libexec/dell_dup:rw"
            "/run/systemd/system:/run/systemd/system"
            "/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
          ];

          extraOptions = [
            "--privileged"
            "--net=host"
            "--device=/dev/mem"
            # "--systemd=always"
          ];
          autoStart = true;
        };

        fastapi-dls = lib.mkIf false {
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

          # autoStart = true;
        };
      };
    };

    powerManagement.powertop.enable = true;

    boot = {
      tmp = {
        useTmpfs = true;
      };

      crashDump = {enable = true;};

      binfmt.emulatedSystems = ["aarch64-linux"];

      kernelParams = [
        "console=tty1"
        "console=ttyS0,115200n8"
        "console=ttyS1,115200n8"
        # "intremap=no_x2apic_optout"
        # "nox2apic"
        "iomem=relaxed"
        "intel_iommu=on"
        "iommu=pt"
        "ipmi_watchdog.timeout=180"
        "iomem=relaxed"
        "mitigations=off"
        "earlyprintk=ttyS0"
        "rootdelay=300"
        "panic=1"
        "boot.panic_on_fail"
        # "video=efifb:off,vesafb:off"
        # "ixgbe.allow_unsupported_sfp=1,1"
        #"vfio-pci.ids=10de:1380,10de:0fbc"
        "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "pci=nomsi"
      ];

      blacklistedKernelModules = ["iTCO_wdt"];

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      loader = {
        systemd-boot = {
          # enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
      };

      extraModulePackages = [config.boot.kernelPackages.vendor-reset];

      initrd = {
        availableKernelModules = [
          # "xhci_pci"
          # "ahci"
          # "usbhid"
          # "usb_storage"
          # # "dell_rbu"
          # 3
          # "dcdbas"
          # # "sd_mod"
        ];
        kernelModules = [
          "acpi_power_meter"
          "acpi_ipmi"
          "ipmi_si"
          "vendor-reset"
          # # "dcdbas"
          # # "dell_rbu"
          # # "pci-me"
          # "kvm-intel"
          # # "mei-me"
          # "uinput"
          # #          "tpm_rng"
          # "ipmi_ssif"
          # "ipmi_ipmb"
          # "ipmi_si"
          # "ipmi_devintf"
          # "ipmi_msghandler"
          # "ipmi_watchdog"
          # "acpi_ipmi"
        ];
      };
      kernelModules = [
        "vendor-reset"
        # "pci-me"
        # "mei-me"
        "coretemp"
        "kvm-intel"
        "uinput"
        "fuse"
        "ipmi_ipmb"
        "acpi_ipmi"
        "acpi_power_meter"
        #       "tpm_rng"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "ipmi_watchdog"
        "dcdbas"
      ];
    };

    systemd = {
      services = {
        "docker-compose@atuin" = {
          wantedBy = ["multi-user.target"];
        };
        "docker-compose@grafana" = {
          wantedBy = ["multi-user.target"];
        };
        "docker-compose@faf" = {
          wantedBy = ["multi-user.target"];
        };
        "docker-compose@esphome" = {
          wantedBy = ["multi-user.target"];
        };
        "docker-compose@tsidp" = {
          wantedBy = ["multi-user.target"];
        };
      };
    };
  };
}
