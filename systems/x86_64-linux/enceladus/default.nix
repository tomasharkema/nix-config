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

    apps = {
      ntopng.enable = true;
      # steam.enable = true;
      # usbip.enable = true;
      hass.enable = true;
      # spotifyd.enable = true;
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
            "3000:3000"
            "69:69/udp"
            "8083:80"
          ];
        };
      };
    };

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      # nvidia.package = mkForce config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services = {
      "nix-private-cache".enable = true;
      local-store.enable = true;
      throttled.enable = lib.mkForce false;
      # remote-builders.server.enable = true;
      blueman.enable = true;

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
      newSubvolumes = true;
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

      interfaces = {
        "enp1s0" = {
          useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
        };
        "vlan800" = {
          useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
        };
      };

      vlans."vlan800" = {
        id = 800;
        interface = "enp1s0";
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

      kernel.sysctl."net.ipv6.conf.enp1s0.disable_ipv6" = true;

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [
          "i915"
          "kvm-intel"
          "uinput"
          "nvme"
        ];
      };
      kernelModules = [
        "amifldrv"
        "i915"
        "kvm-intel"
        "uinput"
        "nvme"
      ];
      # extraModulePackages = [
      #   (pkgs.custom.amifldrv.override {kernel = config.boot.kernelPackages.kernel;})
      # ];
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
