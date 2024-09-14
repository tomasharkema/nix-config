{
  modulesPath,
  lib,
  inputs,
  pkgs,
  config,
  format,
  ...
}: {
  imports = with inputs; [
    # (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIseppvkEAzMD/B2xLqijr4UhTig0bZfqnXS6NcaAHxR root@nixos";
    };

    apps = {
      ntopng.enable = true;
      steam.enable = true;
      # usbip.enable = true;
      # home-assistant.enable = true;
      spotifyd.enable = true;
    };

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      # nvidia.package = mkForce config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services = {
      throttled.enable = lib.mkIf false;
      # remote-builders.client.enable = true;
      blueman.enable = true;
    };

    specialisation = {
      mediacenter.configuration = {
        gui = {
          gnome.enable = false;
          media-center.enable = true;
        };
        apps = {
          cec.enable = true;
        };
      };
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      quiet-boot.enable = true;
      # gamemode.enable = true;
    };

    services.beesd.filesystems = {
      root = {
        spec = "UUID=b4d344ce-bf39-473d-bc97-7b12ef0f97a1";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = [
          "--loadavg-target"
          "2.0"
        ];
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/nvme-512GB_SSD_CN348BH0814055";
      encrypt = true;
      newSubvolumes = true;
    };

    # wifi.enable = true;

    trait = {
      hardware = {
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

    # services = {
    #   pufferpanel = {
    #     enable = true;
    #     extraPackages = with pkgs; [bash curl gawk gnutar gzip];
    #     package = pkgs.buildFHSEnv {
    #       name = "pufferpanel-fhs";
    #       runScript = lib.getExe pkgs.pufferpanel;
    #       targetPkgs = pkgs': with pkgs'; [icu openssl zlib factorio-headless];
    #     };
    #   };
    # };

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
        "i915"
        "kvm-intel"
        "uinput"
        "nvme"
      ];
      extraModulePackages = [];
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
