{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9560-nvidia
    ./hardware-configuration.nix
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
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

    hardware.nvidia.nvidiaPersistenced = false;

    apps = {
      # android.enable = true;
      steam.enable = true;
    };

    headless.hypervisor = {
      enable = true;
      # bridgeInterfaces = ["wlp59s0"];
    };

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        nvidia.enable = true;
        # remote-unlock.enable = true;
      };
    };

    networking = {
      hostName = "euro-mir-2"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall.enable = false;
    };

    services = {
      podman.enable = true;

      avahi = {
        enable = true;
        allowInterfaces = ["wlp59s0"];
        reflector = mkForce false;
      };

      # fprintd = {
      #   enable = true;
      #   package = pkgs.fprintd-tod;
      #   tod = {
      #     enable = true;
      #     driver = pkgs.libfprint-2-tod1-goodix-550a;
      #   };
      # };
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelParams = ["acpi_rev_override=1"];
    };

    programs = {
      mtr.enable = true;
    };
  };
}
