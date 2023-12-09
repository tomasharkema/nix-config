{ self, nixpkgs, nixos-generators, ... }@attrs: {
  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      nixos-generators.nixosModules.all-formats
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/enceladus
    ];
  };
  utm-nixos = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    # specialArgs = { inherit inputs outputs; };
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/utm-nixos/default.nix
    ];
  };
  # hyperv-nixos = nixpkgs.lib.nixosSystem {
  #   system = "x86_64-linux";
  #   modules = [
  #     # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  #     ./overlays/defaults.nix
  #     ./machines/hyperv-nixos/default.nix
  #   ];
  # };
  unraidferdorie = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    # specialArgs = { inherit inputs outputs; };
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/unraidferdorie/default.nix
    ];
  };
}
