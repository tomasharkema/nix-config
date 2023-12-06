{ config, ... }: {
  enceladus = { pkgs, modulesPath, ... }: {
    nixpkgs.system = "x86_64-linux";
    imports = [
      ./overlays/desktop.nix
      # ./overlays/efi.nix
      (modulesPath + "/installer/scan/not-detected.nix")
    ];
    networking.hostName = "enceladus";
    deployment.tags = [ "bare" ];
    deployment = {
      #   targetHost = "100.93.81.142";
      targetHost = "192.168.178.46";
      targetUser = "root";
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/92b9539f-d0c2-47fb-80da-3b7cd0ab6197";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/0146-866A";
      fsType = "vfat";
    };

    swapDevices = [ ];

  };
}
