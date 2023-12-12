{ self, nixpkgs, nixos-generators, inputs, home-manager, vscode-server, agenix
, nix-flatpak, ... }@attrs:

let
  base = {
    imports =
      [ nixos-generators.nixosModules.all-formats ./common/defaults.nix ];
  };
in {
  live = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      ./installer.nix
    ];
  };
  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      base
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
      base
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
    specialArgs = attrs;
    modules = [
      base
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

      base

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

  darwinVM = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    modules = [

      base

      ./machines/utm-nixos/default.nix
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      {
        # virtualisation.vmVariant.virtualisation.graphics = false;
        virtualisation.vmVariant.virtualisation = {
          host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          resolution = {
            x = 1920;
            y = 1080;
          };
          tpm.enable = true;
          cores = 4;
          libvirtd.enable = true;
          spiceUSBRedirection.enable = true;
          forwardPorts = [
            {
              from = "host";
              host.port = 2222;
              guest.port = 22;
            }
            {
              from = "host";
              host.port = 3389;
              guest.port = 3389;
            }
          ];
        };
      }
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
