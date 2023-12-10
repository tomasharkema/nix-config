{ self, nixpkgs, nixos-generators, inputs, home-manager, vscode-server, agenix
, nix-flatpak, ... }@attrs: {
  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      nixos-generators.nixosModules.all-formats
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/enceladus
      ./secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ./home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
      vscode-server.nixosModules.default
      ({ config, pkgs, ... }: { services.vscode-server.enable = true; })

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
      ./secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ./home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  };
  hyperv-nixos = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      ./common/defaults.nix
      ./machines/hyperv-nixos
      ./secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ./home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  };
  unraidferdorie = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    # specialArgs = { inherit inputs outputs; };
    modules = [

      ./common/defaults.nix
      ./machines/unraidferdorie/default.nix
      ./secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ./home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  };
}
