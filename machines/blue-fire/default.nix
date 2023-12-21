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

  networking = { hostName = "blue-fire"; };
  networking.hostId = "529fd7aa";

  environment.systemPackages = with pkgs; [
    # ipmicfg
    ipmiview
    vagrant
  ];

  # Minimal configuration for NFS support with Vagrant.
  services.nfs.server.enable = true;

  # Add firewall exception for VirtualBox provider 
  networking.firewall.extraCommands = ''
    ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
  '';

  # Add firewall exception for libvirt provider when using NFSv4 
  networking.firewall.interfaces."virbr1" = {
    allowedTCPPorts = [ 2049 ];
    allowedUDPPorts = [ 2049 ];
  };

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

  services.prometheus.exporters.ipmi.enable = true;
}
