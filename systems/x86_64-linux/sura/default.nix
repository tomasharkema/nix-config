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
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINd5H6IZiTv8r7FCxgM+GoOzjFLYnax54PPI+vGNpOos root@sura";
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

    services = {
      remote-builders.client.enable = true;
      usbmuxd.enable = true;
      resilio.enable = lib.mkForce false;

      usbguard.enable = lib.mkForce false;
      tlp.enable = lib.mkForce false;
    };

    apps.attic.enable = lib.mkForce false;

    home-manager.users.tomas.dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = true;
      };
    };

    # microsoft-surface = {
    #   surface-control.enable = true;
    # };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome = {
        enable = true;
        # hidpi.enable = true;
      };
      # gamemode.enable = true;
      quiet-boot.enable = true;
    };

    # virtualisation.waydroid.enable = true;

    traits = {
      low-power.enable = true;
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        # intel.enable = true;
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
      scx.enable = lib.mkForce false; # pkgs.stdenvNoCC.isx86_64; # by default uses scx_rustland scheduler
    };

    boot = {
      # kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };
    };
  };
}
