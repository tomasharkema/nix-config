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
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # (pkgs.modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  config = {
    gui = {
      enable = true;
      desktop = {
        rdp.enable = true;
      };
      apps.steam.enable = true;
    };
    traits = {
      # builder.enable = true;
      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K";
      # media = "";
    };

    apps.resilio.root = "/media/resilio";

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    networking = {hostName = "arthur";};
    networking.hostId = "529fd7bb";

    boot = {
      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ehci_pci"
          "ahci"
          "usb_storage"
          "sd_mod"
          "sr_mod"
          "rtsx_pci_sdmmc"
          "amdgpu"
        ];
      };
      kernelModules = ["kvm-intel" "jc42" "tpm_rng"];
      loader = {
        timeout = lib.mkForce 10;
        # grub = {
        #   enable = lib.mkForce true;
        #   # device = "nodev";
        #   efiSupport = true;
        #   efiInstallAsRemovable = true;
        #   # gfxmodeEfi = "1920x1080";
        #   # gfxmodeBios = "1920x1080";
        # };
        # # efi.efiSysMountPoint = "/boot";
      };
    };

    networking.useDHCP = lib.mkDefault true;

    networking.firewall = {
      enable = true;
    };

    services.tcsd.enable = true;

    networking.wireless.enable = lib.mkForce false;

    # environment.persistence."/nix/persistent" = {
    #   hideMounts = true;
    #   directories = [
    #     "/var/log"
    #     "/var/lib/bluetooth"
    #     "/var/lib/nixos"
    #     "/var/lib/systemd/coredump"
    #     "/etc/NetworkManager/system-connections"
    #     {
    #       directory = "/var/lib/colord";
    #       user = "colord";
    #       group = "colord";
    #       mode = "u=rwx,g=rx,o=";
    #     }
    #   ];
    #   files = [
    #     "/etc/machine-id"
    #     {
    #       file = "/etc/nix/id_rsa";
    #       parentDirectory = {mode = "u=rwx,g=,o=";};
    #     }
    #   ];
    # };
  };
}
