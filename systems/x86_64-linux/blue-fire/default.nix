{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the system system.
  config,
  ...
}: {
  # Your configuration.

  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    disks.btrfs = (lib.mkIf (format == "qcow" || format == "iso")) {
      enable = true;
      disks = ["/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K"];
    };

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    programs.nix-ld.enable = true;

    networking = {hostName = "blue-fire";};
    networking.hostId = "529fd7aa";

    environment.systemPackages = with pkgs; [
      # ipmicfg
      ipmiview
      # vagrant
    ];

    # Minimal configuration for NFS support with Vagrant.
    # services.nfs.server.enable = true;

    # # Add firewall exception for VirtualBox provider
    # networking.firewall.extraCommands = ''
    #   ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
    # '';

    # # Add firewall exception for libvirt provider when using NFSv4
    # networking.firewall.interfaces."virbr1" = {
    #   allowedTCPPorts = [ 2049 ];
    #   allowedUDPPorts = [ 2049 ];
    # };

    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;
    # nixpkgs.config.allowUnfree = true;
    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.devices = ["nodev"];

    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    boot.initrd.kernelModules = [
      "kvm-intel"
      "uinput"
      "nvme"
    ];
    boot.kernelModules = ["kvm-intel" "uinput" "nvme" "jc42" "tpm_rng"];
    boot.extraModulePackages = [];

    networking.useDHCP = lib.mkDefault true;

    networking.firewall = {
      enable = lib.mkForce false;
      # enable = true;
    };
    # boot.kernelParams = [ "console=ttyS0,115200" "console=tty1" ];

    # nix.sshServe.enable = true;
    # nix.sshServe.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
    # ];

    services.prometheus.exporters.ipmi.enable = true;

    services.hydra = {
      enable = true;
      hydraURL = "http://localhost:3000"; # externally visible URL
      notificationSender = "hydra@localhost"; # e-mail of hydra service
      # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
      buildMachinesFiles = [];
      # you will probably also want, otherwise *everything* will be built from scratch
      useSubstitutes = true;
    };
  };
}
