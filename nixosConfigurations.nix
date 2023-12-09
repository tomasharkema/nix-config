{ nixpkgs, home-manager, ... }@attrs: {

  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./apps/defaults.nix
      ./machines/enceladus/default.nix
      # home-manager.nixosModules.home-manager
      # {
      #   home-manager.useGlobalPkgs = true;
      #   home-manager.useUserPackages = true;
      #   # home-manager.users.theNameOfTheUser = import ./home.nix;
      # }
    ];
  };
  utm-nixos = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./apps/defaults.nix
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
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./apps/defaults.nix
      ./machines/unraidferdorie/default.nix
    ];
  };
}
