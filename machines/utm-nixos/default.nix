{
  modulesPath,
  lib,
  options,
  ...
}: {
  nixpkgs.system = "aarch64-linux";
  imports = [
    ../../apps/desktop.nix
    # ./overlays/efi.nix
    # ../../common/disks/tmpfs.nix
    ../../common/disks/btrfs.nix
    {_module.args.disks = ["/dev/vda"];}
  ];
  networking.hostName = "utm-nixos";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod"];
  boot.initrd.kernelModules = [
    # "uinput"
  ];
  boot.kernelModules = [
    # "uinput"
  ];
  boot.extraModulePackages = [];
  networking.useDHCP = lib.mkDefault true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable =
    true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable =
    true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  users.users."tomas".extraGroups = ["tss"];
}
