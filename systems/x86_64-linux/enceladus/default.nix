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

    environment.systemPackages = with pkgs; [inteltool];

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
    };

    services = {
      hypervisor.enable = true;
      # "nix-private-cache".enable = true;
      # local-store.enable = true;
      throttled.enable = lib.mkForce false;
      # remote-builders.client.enable = true;
      blueman.enable = true;

      udev.extraRules = ''
        ACTION=="add", ATTRS{idProduct}=="ea60", "ATTRS{idVendor}=="10c4", SYMLINK+="ttyPK0"
      '';

      beesd.filesystems = {
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

    systemd.services."serial-getty@ttyUSB0" = {
      wantedBy = ["multi-user.target"];
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
      quiet-boot.enable = true;
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

    traits = {
      builder.enable = true;

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
        enable = true;
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
        "vlan100" = {
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.102";
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
      };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };
      swraid.enable = true;
      supportedFilesystems = [
        "xfs"
      ];

      kernelParams = [
        "console=ttyUSB0,115200n8"
        "console=tty1"
        "iomem=relaxed"
      ];
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
