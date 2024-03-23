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
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    ./samba.nix
  ];

  config = {
    installed = true;
    apps = {
      ntopng.enable = true;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
      quiet-boot.enable = true;
      game-mode.enable = true;
    };
    # resilio.root = "/opt/media/resilio";
    resilio.enable = mkForce false;
    apps.steam.enable = true;
    systemd.enableEmergencyMode = false;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y";
      # media = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
      encrypt = true;
      newSubvolumes = true;
    };

    wifi.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
        nvidia.enable = true;
      };
    };

    # nixpkgs.system = "x86_64-linux";

    networking = {
      hostName = "enzian";
      hostId = "529fd7fa";
      firewall = {
        enable = true;
      };
      useDHCP = lib.mkDefault false;
      interfaces."enp4s0" = {
        useDHCP = lib.mkDefault true;
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
      nvidia.modesetting.enable = false;
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

    services.podman.enable = true;
    virtualisation = {
      oci-containers.containers = {
        netboot = {
          image = "lscr.io/linuxserver/netbootxyz:latest";
          autoStart = true;
          ports = ["3000:3000" "69:69/udp" "8080:80"];
          # hostname = "ipa.harkema.io";
          # extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0"];
          # cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
          # volumes = [
          #   "/var/lib/freeipa:/data:Z"
          # ];
        };
      };
    };
  };
}
