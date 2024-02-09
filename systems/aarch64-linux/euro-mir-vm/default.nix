{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./hardware-configuration.nix
  ];

  config = {
    networking.hostName = "euro-mir-vm";

    time.timeZone = "Europe/Amsterdam";

    netdata.enable = lib.mkForce false;

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
      apps = {
        flatpak.enable = true;
      };
    };

    boot.growPartition = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };
    services.resilio = {
      enable = lib.mkForce false;
    };
    networking.wireless.enable = lib.mkForce false;

    hardware.opengl = {
      enable = true;
      driSupport = true;
      # driSupport32Bit = true;
    };
  };
}
