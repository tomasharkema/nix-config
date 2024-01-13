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
        vm.enable = true;
      };
    };
    security.ipa = {
      enable = true;
      server = "ipa.harkema.io";
      domain = "harkema.io";
      realm = "HARKEMA.IO";
      basedn = "dc=harkema,dc=io";
      certificate = pkgs.fetchurl {
        url = "https://ipa.harkema.io/ipa/config/ca.crt";
        sha256 = "sha256-3XRsoBALVsBVG9HQfh9Yq/OehvPPiOuZesSgtWXh74I=";
      };
    };
    services.resilio = {
      enable = lib.mkForce false;
    };
    networking.wireless.enable = lib.mkForce false;

    apps.flatpak.enable = false;
    boot.kernelPackages = pkgs.linuxPackages_latest;
  };
}
