{
  modulesPath,
  lib,
  inputs,
  pkgs,
  format,
  ...
}: {
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  config = {
    gui = {
      enable = true;
      desktop = {
        enable = true;
        rdp.enable = true;
      };
    };
    
    
    apps.steam.enable = true;
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y";
      media = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
      encrypt = true;
    };

    wifi.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        remote-unlock.enable = true;
        monitor.enable = true;
      };
    };


    hardware.cpu.intel.updateMicrocode = true;
    nixpkgs.system = "x86_64-linux";

    networking = {
      hostName = "enzian";
      hostId = "529fd7fa";
      firewall = {
        enable = true;
      };
      useDHCP = lib.mkDefault true;
      interfaces."enp4s0".wakeOnLan.enable = true;
    };

    # deployment.tags = [ "bare" ];
    # deployment = {
    #   targetHost = "100.67.118.80";
    #   # targetHost = "192.168.178.46";
    #   targetUser = "root";
    # };

    boot = {binfmt.emulatedSystems = ["aarch64-linux"];

    kernel.sysctl."kernel.sysrq" = 1;
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = ["kvm-intel" "uinput" "nvme"];
      };
      kernelModules = ["kvm-intel" "uinput" "nvme"];
      extraModulePackages = [];
    };
    hardware.bluetooth.enable = true;
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
  };
}
