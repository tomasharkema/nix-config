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

    # nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd

    nixos-hardware.nixosModules.common-gpu-intel
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIa7OowjESNuouZx/QVFryBWjjEHphKDZDq4hOD4C5xS root@schweizer-bobbahn";
    };

    specialisation = {
      mediacenter.configuration = {
        gui = {
          gnome.enable = false;
          media-center.enable = true;
        };
        apps = {
          cec.enable = true;
        };
      };
    };

    environment.systemPackages = with pkgs; [intel-gpu-tools];

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
      # unified-remote.enable = true;
      # cec.enable = true;
    };

    disks.bcachefs = {
      enable = true;
      main = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF01";
    };

    # security = {
    #   ipa = { ifpAllowedUids = mkForce [ "root" "tomas" "media" ]; };
    # };

    resilio.enable = false;

    traits = {
      low-power.enable = true;
      ecrypt.enable = true;
      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        # nvidia.enable = true;
        remote-unlock.enable = false;
        bluetooth.enable = true;
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
      synergy.server = {enable = true;};
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

    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau];
      };
    };
  };
}
