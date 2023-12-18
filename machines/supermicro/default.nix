{ config
, modulesPath
, lib
, inputs
, pkgs
, nixos-hardware
, ...
}: {
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.system = "x86_64-linux";
  programs.nix-ld.enable = true;
  imports = [
    # nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ../../apps/cockpit.nix
    # ../../common/quiet-boot.nix
    # ../../common/game-mode.nix
    # ../../apps/desktop.nix
    # ../../apps/steam.nix
    # ../../common/disks/ext4.nix
    # ../../common/disks/tmpfs.nix
    ../../common/disks/btrfs.nix
    {
      _module.args.disks = [ "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K" ];
    }
  ];

  networking = { hostName = "supermicro"; };
  networking.hostId = "529fd7aa";

  environment.systemPackages = with pkgs; [
    # ipmicfg
    ipmiview
  ];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  nixpkgs.config.allowUnfree = true;
  boot.loader.grub.enable = lib.mkDefault true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [
    "kvm-intel"
    "uinput"
    "nvme"
  ];
  boot.kernelModules = [ "kvm-intel" "uinput" "nvme" "jc42" "tpm_rng" ];
  boot.extraModulePackages = [ ];

  networking.useDHCP = lib.mkDefault true;

  networking.firewall = {
    enable = lib.mkForce false;
    # enable = true;
  };
  boot.kernelParams = [ "console=ttyS0,115200" "console=tty1" ];

  nix.sshServe.enable = true;
  nix.sshServe.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
  ];
}
