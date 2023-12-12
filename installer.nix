{ inputs, modulesPath, lib, ... }:
let
  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
  lib = inputs.nixpkgs.legacyPackages.x86_64-linux.lib;
in {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems =
    lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];
  services.openssh.enable = true;

  users = {
    mutableUsers = true;

    users = {
      root.password = "tomas";
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
      tomas.password = "tomas";
      tomas.isNormalUser = true;
      tomas.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];
    };
  };

  services.tailscale = { enable = true; };
}
