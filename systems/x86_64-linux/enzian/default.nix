{
  modulesPath,
  lib,
  inputs,
  pkgs,
  format,
  ...
}:
with lib; {
  imports = with inputs; [
    # (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # ./samba.nix
  ];

  config = {
    apps = {
      ntopng.enable = true;
      steam.enable = true;
      usbip.enable = true;
      home-assistant.enable = true;
    };

    nix.settings = {
      keep-outputs = mkForce false;
      keep-derivations = mkForce false;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      quiet-boot.enable = true;
      gamemode.enable = true;
    };
    # resilio.root = "/opt/media/resilio";
    # resilio.enable = mkForce false;

    services.beesd.filesystems = {
      root = {
        spec = "UUID=4fb99410-225f-4c6a-a647-2cae35f879f0";
        hashTableSizeMB = 2048;
        verbosity = "crit";
        extraOptions = ["--loadavg-target" "2.0"];
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y";
      media = "/dev/disk/by-id/ata-TOSHIBA_MQ01ABD100_Y6I8PBOHT";
      encrypt = true;
      newSubvolumes = true;
    };

    wifi.enable = true;

    traits = {
      developer.enable = true;
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        nvidia.enable = true;
        disable-sleep.enable = true;

        # nfs = {
        #   enable = true;

        #   machines = {
        #     silver-star.enable = true;
        #     dione.enable = true;
        #   };
        # };
      };
    };

    # nixpkgs.system = "x86_64-linux";

    networking = {
      hostName = "enzian";
      hostId = "529fd7fa";
      firewall = {enable = false;};
      # useDHCP = lib.mkDefault false;
      interfaces."enp4s0" = {
        # useDHCP = lib.mkDefault true;
        wakeOnLan.enable = true;
      };
    };

    # headless.hypervisor = {
    #   enable = true;
    #   bridgeInterfaces = ["enp4s0"];
    # };

    # deployment.tags = [ "bare" ];
    # deployment = {
    #   targetHost = "100.67.118.80";
    #   # targetHost = "192.168.178.46";
    #   targetUser = "root";
    # };

    # services.factorio = {
    #   enable = true;
    #   lan = true;
    # };

    services.pufferpanel = {
      enable = true;
      extraPackages = with pkgs; [bash curl gawk gnutar gzip];
      package = pkgs.buildFHSEnv {
        name = "pufferpanel-fhs";
        runScript = lib.getExe pkgs.pufferpanel;
        targetPkgs = pkgs': with pkgs'; [icu openssl zlib factorio-headless];
      };
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];

      kernel.sysctl."kernel.sysrq" = 1;
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = ["kvm-intel" "uinput" "nvme"];
      };
      kernelModules = ["kvm-intel" "uinput" "nvme"];
      extraModulePackages = [];
    };

    hardware = {
      cpu.intel.updateMicrocode = true;
      bluetooth.enable = true;
      # nvidia.modesetting.enable = false;
      nvidia.nvidiaPersistenced = true;
    };

    services = {
      blueman.enable = true;

      # nfs = {
      #   server = {
      #     enable = true;
      #     exports = ''
      #       /export/media       *(rw,fsid=0,no_subtree_check)
      #     '';
      #   };
      # };
    };

    # fileSystems."/export/media" = {
    #   device = "/media";
    #   options = ["bind"];
    # };

    # services.podman.enable = true;
    # virtualisation = {
    #   oci-containers.containers = {
    #     netboot = {
    #       image = "lscr.io/linuxserver/netbootxyz:latest";
    #       autoStart = true;
    #       ports = ["3000:3000" "69:69/udp" "8080:80"];
    #       # hostname = "ipa.harkema.io";
    #       # extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0"];
    #       # cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
    #       # volumes = [
    #       #   "/var/lib/freeipa:/data:Z"
    #       # ];
    #     };
    #   };
    # };
  };
}
