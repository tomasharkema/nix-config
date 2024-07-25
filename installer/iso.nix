{
  inputs,
  channels,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "${channels.nixpkgs.system}";
  specialArgs = {
    inherit inputs;
  };
  modules = [
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
    ./installer.nix

    (
      {
        lib,
        pkgs,
        ...
      }: {
        config = {
          boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
          networking.wireless.enable = true;
        };
      }
    )
  ];
}
