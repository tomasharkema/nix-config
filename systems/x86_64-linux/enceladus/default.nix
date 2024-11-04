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
          extraOptions = ["--network=host"];
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
      local-store.enable = true;
      throttled.enable = lib.mkForce false;
      remote-builders.server.enable = true;
      blueman.enable = true;

      beesd.filesystems = {
        root = {
          spec = "UUID=7227b9fb-8619-403a-8944-4cc3f615ad6f";
          hashTableSizeMB = 2048;
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
      # useDHCP = lib.mkDefault false;
      # interfaces."enp4s0" = {
      #   useDHCP = lib.mkDefault true;
      #   wakeOnLan.enable = true;
      # };
    };

    boot = {
      tmp = {
        useTmpfs = true;
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
      extraModulePackages = [
        (pkgs.custom.amifldrv.override {kernel = config.boot.kernelPackages.kernel;})
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
