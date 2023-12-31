{
  modulesPath,
  lib,
  inputs,
  pkgs,
  format,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # ../../common/quiet-boot.nix
    # ../../common/game-mode.nix
    # ../../common/wifi.nix
    # ../../apps/desktop.nix
    # ../../apps/steam.nix
    # ./disk-config.nix
    # {
    # _module.args.disks = ["/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y"];
    # }
  ];

  config = {
    gui = {
      enable = true;
      apps.steam.enable = true;
    };

    disks.zfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-HFS128G39TND-N210A_FI71N041410801J4Y";
      media = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
    };

    wifi.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
      };
    };

    boot.binfmt.emulatedSystems = ["aarch64-linux"];
    hardware.cpu.intel.updateMicrocode = true;
    # nixpkgs.system = "x86_64-linux";

    networking = {hostName = "enzian";};
    networking.hostId = "529fd7fa";

    # deployment.tags = [ "bare" ];
    # deployment = {
    #   targetHost = "100.67.118.80";
    #   # targetHost = "192.168.178.46";
    #   targetUser = "root";
    # };

    networking.firewall = {
      enable = true;
    };

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = ["kvm-intel" "uinput" "nvme"];
    boot.kernelModules = ["kvm-intel" "uinput" "nvme"];
    boot.extraModulePackages = [];

    networking.useDHCP = lib.mkDefault true;
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
