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
  imports = with inputs; [
    # (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIseppvkEAzMD/B2xLqijr4UhTig0bZfqnXS6NcaAHxR root@nixos";
    };

    environment.systemPackages = with pkgs; [inteltool];

    apps = {
      ntopng.enable = true;
      steam.enable = true;
      # usbip.enable = true;
      home-assistant.enable = true;
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

      atticd = {
        enable = true;
        environmentFile = "/srv/atticd/.env";
        settings = {
          listen = "[::]:7124";

          api-endpoint = "https://nix.harke.ma/";

          # File storage configuration
          storage = {
            # Storage type
            #
            # Can be "local" or "s3".
            type = "local";

            # ## Local storage

            # The directory to store all files under
            path = "/srv/atticd/storage";
          };

          # Warning: If you change any of the values here, it will be
          # difficult to reuse existing chunks for newly-uploaded NARs
          # since the cutpoints will be different. As a result, the
          # deduplication ratio will suffer for a while after the change.
          chunking = {
            # The minimum NAR size to trigger chunking
            #
            # If 0, chunking is disabled entirely for newly-uploaded NARs.
            # If 1, all NARs are chunked.
            nar-size-threshold = 65536; # chunk files that are 64 KiB or larger

            # The preferred minimum size of a chunk, in bytes
            min-size = 16384; # 16 KiB

            # The preferred average size of a chunk, in bytes
            avg-size = 65536; # 64 KiB

            # The preferred maximum size of a chunk, in bytes
            max-size = 262144; # 256 KiB
          };
          # Compression
          compression = {
            # Compression type
            #
            # Can be "none", "brotli", "zstd", or "xz"
            type = "zstd";

            # Compression level
            level = 9;
          };

          # Garbage collection
          garbage-collection = {
            # The frequency to run garbage collection at
            #
            # By default it's 12 hours. You can use natural language
            # to specify the interval, like "1 day".
            #
            # If zero, automatic garbage collection is disabled, but
            # it can still be run manually with `atticd --mode garbage-collector-once`.
            interval = "12 hours";

            # Default retention period
            #
            # Zero (default) means time-based garbage-collection is
            # disabled by default. You can enable it on a per-cache basis.
            #default-retention-period = "6 months"
          };
        };
      };

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
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
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
      enableIPv6 = false;
      # useDHCP = lib.mkDefault false;
      interfaces."enp1s0" = {
        useDHCP = lib.mkDefault true;
        wakeOnLan.enable = true;
      };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };

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
