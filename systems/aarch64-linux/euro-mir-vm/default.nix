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
    hardware.opengl.enable = true;
    networking.hostName = "euro-mir-vm";

    time.timeZone = "Europe/Amsterdam";

    disks.bcachefs = {
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
        vm.enable = true;
      };
    };
    services.resilio = {
      enable = lib.mkForce false;
    };
    networking.wireless.enable = lib.mkForce false;

    apps.flatpak.enable = false;
  };
}
