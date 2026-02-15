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
        "healthchecks" = lib.mkIf false {
          rekeyFile = ./healthchecks.age;
          group = "healthchecks";
          owner = "healthchecks";
        };
        firefox.rekeyFile = ./firefox.age;
        pocket-id.rekeyFile = ./pocket-id.age;
      };
    };

    hardware.facter = {
      reportPath = ./facter.json;
      # detected.graphics.enable=;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7PJNJ0Y411286E_1-part1";
      boot = "/dev/disk/by-id/usb-DELL_IDSDM_012345678901-0:0";
      snapper.enable = true;
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
        tpm.enable = true;
        secure-boot.enable = true;
        network.xgbe.enable = true;
        nvidia = {
          enable = true;
          open = true;
          beta = true;
          # grid = {
          #   legacy = false;
          # };
        };
      };
    };

    apps = {
      netdata.server.enable = true;
      # netbox.enable = true;
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
      usbguard.enable = false;
    };

    # system.includeBuildDependencies = true;

    programs = {
      nh = {
        clean.enable = true;
        clean.extraArgs = "--keep-since 3M";
      };
      atop = {
        enable = true;
        # netatop.enable = true;
      };
    };

    services = {
      #certmgr.enable = true;
      #step-ca.enable = true;
      #netconsoled.enable = true;
      hypervisor = {
        enable = true;
        iommu.enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };
      rsyncd.enable = true;
      # "nix-private-cache".enable = true;
      #zram-generator.enable = false;
      sonarr.enable = true;
      jackett.enable = true;
      zram-generator.enable = lib.mkForce false;
      snowflake-proxy = {
        enable = true;
        capacity = 8;
        extraFlags = [
          #"-metrics"

          "-ephemeral-ports-range"
          "30000:60000"
        ];
      };

      # syslog-ng = {
      #   enable = true;
      #   extraConfig = ''
      #     source net { udp(ip("0.0.0.0") port(6666)); };
      #     destination netconsole { file("/var/log/syslog/$HOST-netconsole.log"); };
      #     log { source(net); destination(netconsole); };
      #   '';
      # };

      # rsyslogd = {
      #   enable = true;
      #   extraConfig = ''
      #     module(load="imudp")
      #     input(type="imudp" port="6666")
      #     module(load="imtcp")
      #     input(type="imtcp" port="6666")

      #     $template remote-incoming-logs,"/var/log/syslog/%HOSTNAME%/%fromhost-ip%-%$YEAR%-%$MONTH%-%$DAY%.log" *.* ?remote-incoming-logs & ~
      #   '';
      # };
      #
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
        accelerationDevices = [
          "/dev/dri/renderD128"
        ];
        machine-learning = {
          enable = true;
          environment = {
            IMMICH_HOST = lib.mkForce "0.0.0.0";
          };
        };
      };

      irqbalance.enable = true;

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

      lldpd = {
        enable = true;
        extraArgs = [
          "-c"
          "-e"
          "-s"
          "-f"
          "-x"
          "-M 1"
        ];
      };
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

      kanidm = {
        enableClient = true;
        enableServer = true;
        # enablePam = true;
        package = pkgs.kanidm_1_8;

        unixSettings.kanidm = {
          pam_allowed_login_groups = ["users"];
        };

        clientSettings = {
          uri = "https://idm.harkema.io";
        };

        serverSettings = {
          origin = "https://idm.harkema.io";
          domain = "harkema.io";
          tls_chain = "/home/tomas/kanidm-cert/idm.harkema.io/idm.harkema.io.chain.pem";
          tls_key = "/home/tomas/kanidm-cert/idm.harkema.io/idm.harkema.io.priv.key";
          bindaddress = "0.0.0.0:8444";
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

      openvscode-server = {enable = true;};

      tsnsrv = {
        enable = true;

        defaults.authKeyPath = config.age.secrets.tsnsrv.path;

        services = {
          nix-cache = {toURL = "http://127.0.0.1:7124";};
          #searxng = {toURL = "http://127.0.0.1:8088";};
          #glitchtip = {toURL = "http://127.0.0.1:${builtins.toString config.services.glitchtip.port}";};

          grafana = {toURL = "http://127.0.0.1:3000";};
          healthchecks = {toURL = "http://127.0.0.1:8000";};
          # netbox = {toURL = "http://127.0.0.1:8002";};
          netdata = {toURL = "http://127.0.0.1:19999";};
          esphome = {toURL = "http://127.0.0.1:6052";};
          atuin = {toURL = "http://127.0.0.1:8888";};
          trmnl = {toURL = "http://127.0.0.1:2300";};
          immich-ml = {toURL = "http://127.0.0.1:3003";};
          openmanage = {
            toURL = "https://127.0.0.1:1311";
            insecureHTTPS = true;
          };
          termix = {toURL = "http://127.0.0.1:8445";};
          incus = {
            toURL = "https://127.0.0.1:8443";
            insecureHTTPS = true;
          };
        };
      };

      remote-builders.server.enable = true;

      glitchtip = {
        # enable = true;
        port = 8923;
        # listenAddress = "0.0.0.0";

        settings = {
          GLITCHTIP_DOMAIN = "https://glitchtip.ling-lizard.ts.net";
        };
      };

      mysql = {
        enable = true;
        package = pkgs.mariadb;
      };

      firefox-syncserver = {
        enable = true;
        secrets = config.age.secrets.firefox.path;

        database = {
          createLocally = true;
          user = "firefox-syncserver";
          name = "firefox_syncserver";
        };

        singleNode = {
          enable = true;
          hostname = "silver-star.ling-lizard.ts.net";
          url = "http://silver-star.ling-lizard.ts.net:5000";
        };
      };

      pocket-id = lib.mkIf false {
        enable = true;
        settings = {
          APP_URL = "https://id.harke.ma";
          TRUST_PROXY = true;
        };

        environmentFile = config.age.secrets.pocket-id.path;
      };

      cloudflared = {
        enable = true;
        tunnels = {
          "69bc7708-5c7b-422d-b283-9199354f431f" = {
            credentialsFile = config.age.secrets.cloudflared.path;
            default = "http_status:404";
            originRequest.noTLSVerify = true;
            ingress = {
              "id.harke.ma" = {
                service = "http://localhost:1411";
              };
              "idm.harkema.io" = {
                service = "https://127.0.0.1:8444";
              };
            };
          };
        };
      };

      netbootxyz.enable = true;

      # avahi = {
      #   allowInterfaces = ["br0"];
      # };
    };

    networking = {
      hostName = "silver-star";

      firewall = {
        enable = false;
        allowPing = true;
        allowedTCPPorts = [
          1883
          32400
          8443
        ];
        allowedUDPPorts = [
          1883
          32400
          8443
          6666
          6665
        ];
      };

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
        "vlan1" = {
          id = 1;
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
        "vlan1" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
      };

      useDHCP = false;
      networkmanager.enable = true;
    };

    environment = {
      sessionVariables = {
        # LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
      };

      systemPackages = with pkgs; [
        docker-compose
        simpleTpmPk11
        libsmbios
        virt-manager
        ipmitool
        fleet
        openipmi
        freeipmi
        ipmicfg
        ipmiutil
        tremotesf
        redfishtool
        # icingaweb2
      ];
    };
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

      #enableAllFirmware = true;
      #enableRedistributableFirmware = true;

      nvidia = {
        modesetting.enable = false;
        nvidiaSettings = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce true;
      };
    };

    virtualisation = {
      oci-containers.containers = {
        openmanage = {
          image = "teumaauss/srvadmin:latest";
          pull = "always";

          volumes = let
            kernelVersion = config.boot.kernelPackages.kernel.modDirVersion;
          in [
            "/run/current-system/sw/lib/modules/${kernelVersion}:/lib/modules/${kernelVersion}:ro"
            "/sys:/sys:ro"
            "/srv/openmanage/shared:/data"
            "/nix/store:/nix/store:ro"
            "/etc/os-release:/etc/os-release:ro"
            "/usr/libexec/dell_dup:/usr/libexec/dell_dup:rw"
            #"/run/systemd/system:/run/systemd/system"
            #"/var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket"
          ];
          privileged = true;
          devices = ["/dev/mem:/dev/mem"];
          extraOptions = [
            "--net=host"

            # "--systemd=always"
          ];
          autoStart = true;
        };

        termix = {
          image = "ghcr.io/lukegus/termix:latest";
          pull = "always";
          # imageFile = pkgs.dockerTools.pullImage {
          #   imageName = "ghcr.io/lukegus/termix";
          #   imageDigest = "sha256:402f918e3c32aad6d928df8ba6ee39c6fd1a6e250369d86e3a521635a3286a7a";
          #   hash = "sha256-Y6xFFjQPQsLUO+c+Gf1sbzChFx8fhgmnPN7Q1TsJnYY=";
          #   finalImageName = "ghcr.io/lukegus/termix";
          #   finalImageTag = "latest";
          # };
          ports = ["8445:8445"];
          environment = {
            PORT = "8445";
          };
          volumes = ["termix-data:/app/data"];
          autoStart = true;
        };

        fastapi-dls = {
          image = "collinwebdesigns/fastapi-dls:latest";
          pull = "always";
          # imageFile = pkgs.dockerTools.pullImage {
          #   imageName = "collinwebdesigns/fastapi-dls";
          #   imageDigest = "sha256:bd62fc80bdf3ca6383b443498e2f553690d2ce111254204f581926e1505acb56";
          #   hash = "sha256-JDZ7pQG2WUVntMsw3ny4N6F+Rc3pwazTX2YFhf8bC4I=";
          #   finalImageName = "collinwebdesigns/fastapi-dls";
          #   finalImageTag = "latest";
          # };

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
      kernel.sysctl = {
        "kernel.unknown_nmi_panic" = 1;
      };

      # binfmt.emulatedSystems = ["aarch64-linux"];

      kernelParams = [
        "console=tty1"
        "console=ttyS0,115200n8r"
        # "console=ttyS1,115200n8"
        # "earlyprintk=ttyS0"
        # "intremap=no_x2apic_optout"
        # "nox2apic"

        "mitigations=off"
        "intel_iommu=on"
        "iommu=pt"
        "ipmi_watchdog.timeout=180"
        "rootdelay=300"
        "panic=1"
        "boot.panic_on_fail"
        # "video=efifb:off,vesafb:off"
        # "ixgbe.allow_unsupported_sfp=1,1"
        #"vfio-pci.ids=10de:1380,10de:0fbc"
        #"pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "pci=nomsi"
      ];

      blacklistedKernelModules = ["iTCO_wdt"];

      kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-server;

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

      # do some research for this!
      extraModulePackages = [config.boot.kernelPackages.vendor-reset];
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
        # "docker-compose@grafana" = {
        #   wantedBy = ["multi-user.target"];
        # };
        # "docker-compose@faf" = {
        #   wantedBy = ["multi-user.target"];
        # };
        "docker-compose@esphome" = {
          wantedBy = ["multi-user.target"];
        };
        # "docker-compose@fleetdm" = {
        #   wantedBy = ["multi-user.target"];
        # };
        "docker-compose@tsidp" = {
          wantedBy = ["multi-user.target"];
        };
      };
    };
  };
}
