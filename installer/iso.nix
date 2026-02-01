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
          hardware.firmware = lib.mkIf (pkgs.stdenv.isAarch64) [
            inputs.self.packages.aarch64-linux.surface-pro-12-linux
          ];
          # networking.wireless.enable = true;
        };
      }
    )
  ];
}
