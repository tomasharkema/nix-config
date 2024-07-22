{
  inputs,
  channels,
}:
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit inputs;
  };
  modules = [
    "${inputs.nixpkgs}/nixos/modules/installer/netboot/netboot-minimal.nix"
    ./installer.nix

    (
      {
        lib,
        pkgs,
        config,
        ...
      }: {
        config = {
          boot = {
            supportedFilesystems.zfs = lib.mkForce false;
            kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
          };
          system.stateVersion = config.system.nixos.release;
          netboot.squashfsCompression = "zstd -Xcompression-level 6";
          networking.wireless.enable = true;
        };
      }
    )
  ];
}
