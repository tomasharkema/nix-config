# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # boot.initrd.availableKernelModules =
  # [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  # boot.initrd.kernelModules = [ ];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  swapDevices = [
    # { device = "/dev/disk/by-uuid/ee4e62c6-5507-4312-ac5e-4e69a06baf24"; }
    # { device = "/dev/disk/by-uuid/e93d553b-3fda-47e9-97ec-38d997b1a1f3"; }
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
