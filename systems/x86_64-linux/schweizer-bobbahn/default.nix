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
    gui."media-center".enable = true;

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
      game-mode.enable = false;
      quiet-boot.enable = true;
    };

    resilio.enable = false;

    traits = {
      hardware = {
        # tpm.enable = true;
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
      clipmenu.enable = mkForce false;
      synergy.server = {
        # enable = true;
      };
      atop.enable = mkForce false;

      avahi = {
        enable = true;
        allowInterfaces = ["wlo1"];
        reflector = mkForce false;
      };
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau];
    };
  };
}
