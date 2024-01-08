{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
  ];

  config = {
    networking.hostName = "euro-mir-vm";
  };
}
