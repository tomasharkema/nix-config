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
    networking = {
      wireless.enable = mkForce false;
      hostName = "euro-mir-vm";
    };

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
      # quiet-boot.enable = true;
      gnome.enable = false;
      pantheon.enable = true;
    };
    apps.flatpak.enable = true;
    boot.growPartition = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };

    services.resilio.enable = mkForce false;

    # hardware.opengl = {
    #   enable = true;
    #   driSupport = true;
    #   # driSupport32Bit = true;
    # };
  };
}
