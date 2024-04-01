{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./hardware-configuration.nix
  ];

  config = {
    # nixpkgs.crossSystem.system = "aarch64-linux";
    installed = true;
    networking = {
      wireless.enable = mkForce false;
      hostName = "euro-mir-vm";
    };

    nix.buildMachines = [
      {
        hostName = "blue-fie";
        systems = ["aarch64-linux" "x86_64-linux"];
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 100;
      }
    ];

    users.mutableUsers = true;

    time.timeZone = "Europe/Amsterdam";

    disks."ext4" = {
      enable = true;
      main = "/dev/vda";
      encrypt = false;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      quiet-boot.enable = false;
      gnome.enable = true;
    };

    apps = {
      flatpak.enable = true;
      # opensnitch.enable = true;
    };

    boot.growPartition = true;

    traits = {
      developer.enable = false;
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };
    resilio.enable = false;

    hardware.opengl = {
      enable = true;
      driSupport = true;
      #   # driSupport32Bit = true;
    };
  };
}
