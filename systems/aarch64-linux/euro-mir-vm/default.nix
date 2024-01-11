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
        disks.btrfs = {
      enable = true;
      main = "/dev/vda";
        };
    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
    };
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
      };
    };
    services.resilio = {
      enable = lib.mkForce false;
    };
    networking.wireless.enable = lib.mkForce false;
  };
}
