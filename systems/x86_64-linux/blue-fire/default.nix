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
in {
  # Your configuration.

  imports = with inputs; [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.supermicro-x10sll-f
  ];

  config = with lib; {
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";
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
      };
    };

    headless.enable = true;

    # services = {
    # podman.enable = true;
    # freeipa.replica.enable = true;
    # };

    networking = {
      hostName = "blue-fire";
      hostId = "529fd7aa";

      firewall = {
        enable = mkForce false;
      };

      useDHCP = false;

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
      bridgeInterfaces = ["eno1"];
    };

    services.ntopng = {
      enable = true;
      httpPort = 3457;
      extraConfig = ''
        --http-prefix="/ntopng"
      '';
    };

    proxy-services.services = {
      "/ntopng" = {
        proxyPass = "http://localhost:${toString config.services.ntopng.httpPort}/";
        extraConfig = ''
          rewrite /ntopng(.*) $1 break;
        '';
      };
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
    ];

    # virtualisation = {
    #   oci-containers.containers = {
    #     go-nixos-menu = {
    #       image = "docker.io/tomasharkema7/go-nixos-menu";
    #       autoStart = true;
    #       ports = ["3001:3000"];
    #     };
    #   };
    # };

    services = {
      # ha.initialMaster = true;
      # command-center = {
      #   enableBot = true;
      # };

      # hercules-ci-agent = {enable = true;};
      tailscale = {
        useRoutingFeatures = lib.mkForce "both";
      };
      tcsd.enable = true;

      prometheus.exporters.ipmi.enable = true;

      nfs = {
        server = {
          enable = true;
          exports = ''
            /export/media        *(rw,fsid=0,no_subtree_check)
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [2049];

    fileSystems = {
      "/export/media" = {
        device = "/media";
        options = ["bind"];
      };
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
        availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
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
      # kernelParams = ["console=ttyS0,115200" "console=tty1"];
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
