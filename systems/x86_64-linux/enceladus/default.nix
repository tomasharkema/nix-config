{
  modulesPath,
  lib,
  inputs,
  pkgs,
  config,
  format,
  ...
}: let
  self = inputs.self;
in {
  config = {
    facter.reportPath = ./facter.json;

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIseppvkEAzMD/B2xLqijr4UhTig0bZfqnXS6NcaAHxR root@nixos";
    };

    environment.systemPackages = with pkgs; [
      inteltool
      rtl-sdr
    ];

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      rtl-sdr.enable = true;
    };

    apps.podman.enable = true;

    services = {
      hypervisor.enable = true;
      # "nix-private-cache".enable = true;
      # local-store.enable = true;
      throttled.enable = lib.mkForce false;
      # remote-builders.client.enable = true;
      blueman.enable = true;

      udev = {
        packages = with pkgs; [
          # rtl-sdr
        ];

        # extraRules = ''
        #   ACTION=="add", ATTRS{idProduct}=="ea60", "ATTRS{idVendor}=="10c4", SYMLINK+="ttyPK0"
        # '';
      };

      beesd.filesystems = lib.mkIf false {
        root = {
          spec = "UUID=7227b9fb-8619-403a-8944-4cc3f615ad6f";
          hashTableSizeMB = 1024;
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "2.0"
          ];
        };
      };
    };

    virtualisation = {
      oci-containers.containers = {
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
      };
    };

    # specialisation = {
    #   mediacenter.configuration = {
    #     gui = {
    #       gnome.enable = false;
    #       # media-center.enable = true;
    #     };
    #     apps = {
    #       cec.enable = true;
    #     };
    #   };
    # };

    gui = {
      # enable = true;
      desktop = {
        # enable = true;
        # rdp.enable = true;
      };
      #quiet-boot.enable = true;
      # gamemode.enable = true;
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-512GB_SSD_CN348BH0814055";
      encrypt = true;
      newSubvolumes.enable = true;
      snapper.enable = false;
    };

    # wifi.enable = true;

    systemd.services = {
      "docker-compose@adsb".wantedBy = ["multi-user.target"];
      "docker-compose@ser2net".wantedBy = ["multi-user.target"];
    };

    traits = {
      hardware = {
        # intel.enable = true;
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        disable-sleep.enable = true;
      };
    };

    networking = {
      hostName = "enceladus";

      firewall = {
        enable = false;
      };

      bridges.br0 = {
        interfaces = ["enp1s0"];
      };

      interfaces = {
        "enp1s0" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "vlan800" = {
          mtu = 9000;
          useDHCP = lib.mkDefault true;
        };
        "vlan69" = {
          ipv4.addresses = [
            {
              address = "192.168.69.40";
              prefixLength = 24;
            }
          ];
        };
        "vlan100" = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.103";
              prefixLength = 24;
            }
          ];
          wakeOnLan.enable = true;
        };
      };

      vlans = {
        "vlan800" = {
          id = 800;
          interface = "enp1s0";
        };
        "vlan100" = {
          id = 100;
          interface = "enp1s0";
        };
        "vlan69" = {
          id = 69;
          interface = "enp1s0";
        };
      };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };

      # swraid.enable = true;
      # supportedFilesystems = [
      #   "xfs"
      # ];
      kernelModules = ["iTCO_wdt"];
      kernelParams = [
        "console=ttyUSB0,115200n8"
        "console=tty1"
        # "iomem=relaxed"
      ];
      initrd.kernelModules = ["iTCO_wdt"];
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
