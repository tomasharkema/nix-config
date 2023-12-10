{ modulesPath, lib, ... }: {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.system = "x86_64-linux";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # ./overlays/qemu.nix
    ../../apps/desktop.nix
    ../../apps/steam.nix
    # ./overlays/efi.nix 
    "${
      builtins.fetchTarball {
        url = "https://github.com/nix-community/disko/archive/master.tar.gz";
        sha256 = "sha256:0khjn8kldipsr50m15ngnprzh1pzywx7w5i8g36508l4p7fbmmlm";
      }
    }/module.nix"
    ./disk-config.nix
    { _module.args.disks = [ "/dev/vda" ]; }
  ];

  # _module.check = false;
  # deployment.networking.hostName = "unraidferdorie";
  networking.hostId = "1839f4ed";
  #   boot.loader.systemd-boot.enable = true;
  #   boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules =
    [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  #   fileSystems."/" = {
  #     device = "/dev/disk/by-uuid/7cfeeb6a-9324-4e8c-ad49-99a2dacba295";
  #     fsType = "ext4";
  #   };

  #   fileSystems."/boot" = {
  #     device = "/dev/disk/by-uuid/A890-75D3";
  #     fsType = "vfat";
  #   };
}
