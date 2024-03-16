{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "sd_mod" "sr_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  # fileSystems."/" =
  #   { device = "/dev/disk/by-uuid/c20d4ded-ae5c-4524-912f-6cc95720c3fe";
  #     fsType = "ext4";
  #   };

  # fileSystems."/boot" =
  #   { device = "/dev/disk/by-uuid/ECB5-35FC";
  #     fsType = "vfat";
  #   };

  # swapDevices =
  #   [ { device = "/dev/disk/by-uuid/92340271-4d84-4839-926f-748917697f3d"; }
  #   ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
