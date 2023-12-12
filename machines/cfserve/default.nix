{ config, modulesPath, lib, inputs, pkgs, ... }: {

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.system = "x86_64-linux";

  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    ../../common/quiet-boot.nix
    ../../common/game-mode.nix
    ../../apps/desktop.nix
    ../../apps/steam.nix
    "${
      builtins.fetchTarball {
        url = "https://github.com/nix-community/disko/archive/master.tar.gz";
        sha256 = "sha256:0khjn8kldipsr50m15ngnprzh1pzywx7w5i8g36508l4p7fbmmlm";
      }
    }/module.nix"
    ../../common/disks/ext4.nix
    {
      _module.args.disks = [ "/dev/sda" ];
      # [ "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K" ];
    }
  ];

  networking = { hostName = "cfserve"; };
  networking.hostId = "529fd7fb";

  users.groups.input.members = [ "tomas" ];

  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "kvm-intel" "uinput" "nvme" ];
  boot.kernelModules = [ "kvm-intel" "uinput" "nvme" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  networking.firewall = {
    enable = lib.mkForce false;
    # enable = true;
  };
}
