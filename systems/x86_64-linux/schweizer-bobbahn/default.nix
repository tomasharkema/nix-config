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
    nixos-hardware.nixosModules.common-gpu-intel
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa7OowjESNuouZx/QVFryBWjjEHphKDZDq4hOD4C5xS root@schweizer-bobbahn";
    };

    powerManagement.enable = true;

    environment = {
      sessionVariables = {
        LIBVA_DRIVER_NAME = "i965";
      };
      systemPackages = with pkgs; [intel-gpu-tools];
    };

    gui = {
      enable = true;
      desktop.enable = true;
      gnome.enable = mkDefault true;
      quiet-boot.enable = true;
    };

    # apps.spotifyd.enable = true;

    apps = {
      steam.enable = true;
      # usbip.enable = true;
      netdata.enable = true;
      unified-remote.enable = true;
      # cec.enable = true;
    };

    disks.bcachefs = {
      enable = true;
      main = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
    };

    # security = {
    #   ipa = { ifpAllowedUids = mkForce [ "root" "tomas" "media" ]; };
    # };

    apps.resilio.enable = false;

    trait = {
      low-power.enable = true;
      ecrypt.enable = true;
      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        # nvidia.enable = true;
        remote-unlock.enable = false;
        bluetooth.enable = true;

        disable-sleep.enable = true;
      };
    };

    networking = {
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall.enable = true;
    };

    # programs = { atop.enable = mkForce false; };

    services = {
      remote-builders.client.enable = true;
      # podman.enable = true;
      clipmenu.enable = mkForce false;
      # synergy.server = {enable = true;};
      avahi = {
        enable = true;
        # allowInterfaces = [ "wlo1" ];
        reflector = mkForce false;
      };
    };

    # boot.recovery = {
    #   enable = false;
    #   install = false;
    # };

    zramSwap = {enable = true;};

    boot = {
      kernelModules = [
        "i915"
      ];
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
          vaapiVdpau
          vpl-gpu-rt
        ];
      };
    };
  };
}
