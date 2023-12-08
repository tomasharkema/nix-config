{ pkgs, modulesPath, lib, options, ... }: {
  nixpkgs.system = "aarch64-linux";
  imports = [
    ../../overlays/desktop.nix
    # ./overlays/efi.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    "${
      builtins.fetchTarball {
        url = "https://github.com/nix-community/disko/archive/master.tar.gz";
        sha256 = "sha256:0khjn8kldipsr50m15ngnprzh1pzywx7w5i8g36508l4p7fbmmlm";
      }
    }/module.nix"
    ./disk-config.nix
    { _module.args.disks = [ "/dev/vda" ]; }
  ];
  networking.hostName = "utm-nixos";
  networking.networkmanager.enable = true;
  _module.check = false;

  deployment = {
    tags = [ "vm" ];
    targetHost = "100.89.103.83";
    # targetHost = "10.211.70.5";

    # targetHost = "192.168.178.241";
    targetUser = "root";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
  boot.initrd.kernelModules = [
    # "uinput" 
  ];
  boot.kernelModules = [
    # "uinput"
  ];
  boot.extraModulePackages = [ ];
  # services.btrfs.autoScrub.enable = true;
  # services.snapper = { enable = true; };
  networking.useDHCP = lib.mkDefault true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
