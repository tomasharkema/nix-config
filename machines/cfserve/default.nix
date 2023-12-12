{ config, modulesPath, lib, inputs, pkgs, ... }: {

  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.system = "x86_64-linux";

  imports = [
    # inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-pc-ssd
    (modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
    # ../../common/quiet-boot.nix
    # ../../common/game-mode.nix
    # ../../apps/desktop.nix
    # ../../apps/steam.nix
    # ../../common/disks/tmpfs.nix
    # ../../common/disks/ext4.nix
    ../../common/disks/zfs.nix
    {
      _module.args.disks = [ "/dev/sda" ];
      # [ "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K" ];
    }
  ];

  networking = { hostName = "cfserve"; };
  networking.hostId = "529fd7bb";

  users.groups.input.members = [ "tomas" ];

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
    kernelModules = [ "kvm-intel" ];
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        gfxmodeEfi = "1920x1080";
        gfxmodeBios = "1920x1080";
      };
      efi.efiSysMountPoint = "/boot";
    };
  };

  networking.useDHCP = lib.mkDefault true;

  networking.firewall = {
    enable = lib.mkForce false;
    # enable = true;
  };

  # environment.persistence."/persistent" = {
  #   hideMounts = true;
  #   directories = [
  #     "/nix"
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
  #       parentDirectory = { mode = "u=rwx,g=,o="; };
  #     }
  #   ];
  #   users.tomas = {
  #     directories = [
  #       "Downloads"
  #       "Music"
  #       "Pictures"
  #       "Documents"
  #       "Videos"
  #       "VirtualBox VMs"
  #       {
  #         directory = ".gnupg";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".ssh";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".nixops";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".local/share/keyrings";
  #         mode = "0700";
  #       }
  #       ".local/share/direnv"
  #     ];
  #     files = [ ".screenrc" ];
  #   };
  # };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
  users.users."tomas".extraGroups = [ "tss" ];
  boot.initrd.systemd.enableTpm2 = true;
  services.tcsd.enable = true;
}
