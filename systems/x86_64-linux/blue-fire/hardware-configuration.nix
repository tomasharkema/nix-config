{
  config,
  lib,
  pkgs,
  modulesPath,
  nixos-hardware,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "ums_realtek"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  # swapDevices = [
  #   { device = "/dev/disk/by-uuid/90a80013-f094-4d41-aa50-1bc76908acc2"; }
  #   { device = "/dev/disk/by-uuid/f1f5939b-1620-4e6d-b19a-00ff82ea0bb4"; }
  # ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno3.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno4.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0f0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0f1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0f2.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0f3.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
