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
    # nixos-hardware.nixosModules.common-cpu-intel
    # nixos-hardware.nixosModules.common-pc-ssd
    # nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    # ./samba.nix
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHlUmrtTg5ukrLboFA6wZUKlqsUEChJD8qpekxEIu9wL root@enzian";
    };

    hardware.facter.reportPath = ./facter.json;

    apps = {
      #steam.enable = true;
      # usbip.enable = true;
      # home-assistant.enable = true;
      resilio.enable = lib.mkForce false;
    };

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    # specialisation = {
    #   mediacenter.configuration = {
    #     gui = {
    #       gnome.enable = false;
    #       media-center.enable = true;
    #     };
    #     apps = {
    #       cec.enable = true;
    #     };
    #   };
    # };

    # gui = {
    #   enable = true;
    #   desktop = {
    #     enable = true;
    #   };
    #   quiet-boot.enable = true;
    #   gamemode.enable = true;
    # };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y";
      #media = "/dev/disk/by-id/ata-TOSHIBA_MQ01ABD100_Y6I8PBOHT";
      encrypt = true;
      newSubvolumes.enable = true;
    };

    # wifi.enable = true;

    traits = {
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        nvidia = {
          enable = true;
          open = false;
        };
        disable-sleep.enable = true;
      };
    };

    networking = {
      hostName = "enzian";

      firewall = {
        enable = true;
      };
      # useDHCP = lib.mkDefault false;
      interfaces."enp4s0" = {
        useDHCP = lib.mkDefault true;
        wakeOnLan.enable = true;
      };
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
      kernelPackages = lib.mkForce pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
      kernelModules = [
        "kvm-intel"
        "uinput"
        "nvme"
        "coretemp"
        "nct6775"
      ];
      extraModulePackages = [];
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      # nvidia.package = mkForce config.boot.kernelPackages.nvidiaPackages.stable;
    };

    services = {
      #remote-builders.client.enable = true;
      # blueman.enable = true;
    };
  };
}
