{ self, nixpkgs, nixos-generators, inputs, home-manager, ... }@attrs: {
  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      nixos-generators.nixosModules.all-formats
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/enceladus
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas = import ./home.nix;
      }
    ];
  };
  utm-nixos = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    # specialArgs = { inherit inputs outputs; };
    modules = [
      nixos-generators.nixosModules.all-formats
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
