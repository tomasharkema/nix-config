{ pkgs, modulesPath, lib, options, ... }: {
  nixpkgs.system = "aarch64-linux";
  imports = [
    ../overlays/desktop.nix
    # ./overlays/efi.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];
  networking.hostName = "utm-nixos";
  networking.networkmanager.enable = true;
  _module.check = false;

  deployment = {
    tags = [ "vm" ];
    # targetHost = "100.121.109.15";
    # targetHost = "10.211.70.5";

    targetHost = "192.168.178.240";
    targetUser = "root";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = lib.mkDefault {
    device = "/dev/vda2";
    fsType = "ext4";
  };

  fileSystems."/boot" = lib.mkDefault {
    device = "/dev/vda1";
    fsType = "vfat";
  };

  swapDevices = [ ];
  #   networking.useDHCP = lib.mkDefault true;
}
