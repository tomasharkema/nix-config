{
  modulesPath,
  lib,
  ...
}: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  nixpkgs.system = "x86_64-linux";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    # ./overlays/qemu.nix
    ../../apps/desktop.nix
    ../../apps/steam.nix
    # ./overlays/efi.nix
    ../../common/disks/btrfs.nix
    {_module.args.disks = ["/dev/vda"];}
  ];

  networking.hostName = lib.mkForce "silver-star-ferdorie";
  networking.hostId = "1839f4ed";
  #   boot.loader.systemd-boot.enable = true;
  #   boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules = ["uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  networking.firewall = {
    enable = false;
    # enable = true;
  };
  services.resilio = {
    enable = lib.mkForce false;
  };

  nix.sshServe.enable = true;
  nix.sshServe.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
  ];
}
