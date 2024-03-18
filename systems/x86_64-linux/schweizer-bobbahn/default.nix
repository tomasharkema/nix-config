{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  config = {
    installed = true;

    traits.low-power.enable = true;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
      encrypt = true;
      newSubvolumes = true;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome.enable = true;
      game-mode.enable = true;
      quiet-boot.enable = true;
    };

    apps = {
      # android.enable = true;
      # steam.enable = true;
      # opensnitch.enable = true;
    };

    resilio.enable = false;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        # nvidia.enable = true;
        remote-unlock.enable = true;
      };
    };

    networking = {
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall.enable = true;
    };

    services = {
      # podman.enable = true;

      synergy.server = {
        # enable = true;
      };

      avahi = {
        enable = true;
        allowInterfaces = ["wlo1"];
        reflector = mkForce false;
      };
    };

    boot = {
      # binfmt.emulatedSystems = ["aarch64-linux"];
      # kernelParams = ["acpi_rev_override=1"];
    };

    programs = {
      mtr.enable = true;
      flashrom.enable = true;
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
}
