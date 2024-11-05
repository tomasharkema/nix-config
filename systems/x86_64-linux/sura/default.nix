{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.microsoft-surface-pro-intel

    nixos-hardware.nixosModules.microsoft-surface-common
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMESuHxB6/b4HP0S/Ad76XIR5s473hvPXFN8uzjhFZBp root@voltron";
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-C400-MTFDDAT128MAM_0000000013050365897F";
      encrypt = true;
      newSubvolumes = true;
      # btrbk.enable = true;
      snapper.enable = true; # false;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome = {
        enable = true;
        # hidpi.enable = true;
      };
      gamemode.enable = true;
      quiet-boot.enable = true;
    };

    virtualisation.waydroid.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        intel.enable = true;
        bluetooth.enable = true;
      };
    };
    networking = {
      hostName = "sura"; # Define your hostname.
      networkmanager.enable = true;
      firewall = {
        enable = true;
      };
    };

    chaotic = {
      scx.enable = pkgs.stdenvNoCC.isx86_64; # by default uses scx_rustland scheduler
    };

    boot = {
      kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
