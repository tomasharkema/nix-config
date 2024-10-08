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
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
    ./installer.nix

    (
      {
        lib,
        pkgs,
        ...
      }: {
        config = {
          networking.wireless.enable = true;
        };
      }
    )
  ];
}
