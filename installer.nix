{
  inputs,
  modulesPath,
  lib,
  ...
}: let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  inherit (inputs.nixpkgs.legacyPackages.x86_64-linux) lib;
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./user-defaults.nix
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems =
    lib.mkForce ["btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs"];
  services.openssh.enable = true;

  users.mutableUsers = true;

  users.users = {
    root.password = "tomas";
    tomas.password = "tomas";
    tomas.extraGroups = ["wheel" "tomas"];
    tomas.isNormalUser = true;
  };

  services.tailscale = {enable = true;};

  boot.hardwareScan = true;

  services.udev = {enable = true;};

  environment.systemPackages = with pkgs; [btop git wget curl];

  boot.kernelModules = ["zfs"];
}
