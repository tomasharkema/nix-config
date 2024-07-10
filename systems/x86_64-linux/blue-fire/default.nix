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
in {
  imports = with inputs; [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.supermicro-x10sll-f
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";
      btrbk.enable = false;
    };

    services.beesd.filesystems = {
      root = {
        spec = "UUID=3b512fef-be0f-4fb0-aaef-40fe4fa01b2e";
        hashTableSizeMB = 1024;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "2.0"
        ];
      };
    };

    traits = {
      builder = {
        enable = true;
        hydra.enable = true;
      };
      hardware = {
        # tpm.enable = true;
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

    services.cron.systemCronJobs = [
      # Reset 5-minute watchdog timer every minute
      "* * * * * ${pkgs.ipmitool}/bin/ipmitool raw 0x30 0x97 1 5"
    ];

    headless.enable = true;

    apps = {
      # attic-server.enable = true;
      ntopng.enable = true;
      atop = {
        enable = true;
        httpd = true;
      };
    };

    gui = {
      icewm.enable = true;
      # desktop.enable = true;
    };

    services = {
      builder-service.enable = true;
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

      tcsd.enable = true;
      kmscon.enable = mkForce false;

      prometheus.exporters.ipmi.enable = true;

      # nfs = {
      #   server = {
      #     enable = true;
      #     exports = ''
      #       /export/media        *(rw,fsid=0,no_subtree_check)
      #     '';
      #   };
      # };
    };

    apps.podman.enable = true;

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
        enable = false;
        allowPing = true;
      };

      # useDHCP = false;
      networkmanager.enable = false;

      interfaces = {
        "eno1" = {
          useDHCP = true;
          wakeOnLan.enable = true;
        };
        "eno2" = {
          useDHCP = true;
          wakeOnLan.enable = true;
        };
        "eno3" = {
          useDHCP = true;
          wakeOnLan.enable = true;
        };
        "eno4" = {
          useDHCP = true;
          wakeOnLan.enable = true;
        };
      };
    };

    headless.hypervisor = {
      enable = true;
      # bridgeInterfaces = [ "eno1" ];
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      ipmiview
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

    services.factorio.enable = true;

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

    # systemd.network = {
    #   enable = true;
    #   netdevs = {
    #     "10-bond0" = {
    #       netdevConfig = {
    #         Kind = "bond";
    #         Name = "bond0";
    #       };
    #       bondConfig = {
    #         Mode = "802.3ad";
    #         TransmitHashPolicy = "layer3+4";
    #       };
    #     };
    #   };
    #   networks = {
    #     "30-eno1" = {
    #       matchConfig.Name = "eno1";
    #       networkConfig.Bond = "bond0";
    #     };
    #     "30-eno2" = {
    #       matchConfig.Name = "eno2";
    #       networkConfig.Bond = "bond0";
    #     };
    #     "30-eno3" = {
    #       matchConfig.Name = "eno3";
    #       networkConfig.Bond = "bond0";
    #     };
    #     "30-eno4" = {
    #       matchConfig.Name = "eno4";
    #       networkConfig.Bond = "bond0";
    #     };
    #     "40-bond0" = {
    #       matchConfig.Name = "bond0";
    #       linkConfig = {
    #         RequiredForOnline = "carrier";
    #       };
    #       networkConfig.LinkLocalAddressing = "no";
    #     };
    #   };
    # };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];

      loader = {
        # systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        # systemd-boot.configurationLimit = 10;
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [
          "kvm-intel"
          "uinput"
          "nvme"
          # "tpm_rng"
          "ipmi_ssif"
          "acpi_ipmi"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
        ];
      };
      kernelModules = [
        "kvm-intel"
        "uinput"
        "nvme"
        "tpm_rng"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "watchdog"
      ];
      extraModulePackages = [];
      kernelParams = ["console=tty0" "console=ttyS1,115200n8"];
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
