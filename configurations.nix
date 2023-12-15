{ self
, nixpkgs
, nixos-generators
, inputs
, home-manager
, vscode-server
, agenix
, nix-flatpak
, disko
, impermanence
, ...
} @ attrs:
let
  base = {
    imports = [ nixos-generators.nixosModules.all-formats ./common/defaults.nix ];
  };
in
{
  live = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      ./installer.nix
    ];
  };
  netboot = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ({ config
       , pkgs
       , lib
       , modulesPath
       , ...
       }: {
        imports = [ (modulesPath + "/installer/netboot/netboot-minimal.nix") ];
        config = {
          ## Some useful options for setting up a new system
          # services.getty.autologinUser = lib.mkForce "root";
          # users.users.root.openssh.authorizedKeys.keys = [ ... ];
          # console.keyMap = "de";
          # hardware.video.hidpi.enable = true;

          system.stateVersion = config.system.nixos.release;
        };
      })
    ];
  };
  enceladus = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit attrs;
    };

    # specialArgs = { inherit inputs outputs; };
    modules = [
      base
      disko.nixosModules.default
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
      # vscode-server.nixosModules.default
      # ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
    ];
  };

  supermicro = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      # ./user-defaults.nix
      base
      disko.nixosModules.default
      impermanence.nixosModules.impermanence
      ./machines/supermicro
      ./secrets
      agenix.nixosModules.default
      ({
        imports = [ ./packages/common.nix ];
      })
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
  utm-nixos = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    # specialArgs = { inherit inputs outputs; };
    modules = [
      base
      disko.nixosModules.default
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
      disko.nixosModules.default
      ./machines/hyperv-nixos
      ./secrets
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
      disko.nixosModules.default
      ./machines/unraidferdorie/default.nix
      ./secrets
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

  cfserve = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      # ./user-defaults.nix
      base
      impermanence.nixosModule
      disko.nixosModules.default
      ./machines/cfserve
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
      ({ config
       , pkgs
       , ...
       }: { services.vscode-server.enable = true; })
    ];
  };


  unraid = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      # ./user-defaults.nix
      base
      # impermanence.nixosModule
      # disko.nixosModules.default
      # ./machines/cfserve
      ./secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      ({
        boot.isContainer = true;
      })
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          agenix.homeManagerModules.default
          ./home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
      vscode-server.nixosModules.default
      ({ config
       , pkgs
       , ...
       }: { services.vscode-server.enable = true; })
    ];
  };


  darwinVM = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    modules = [
      base
      ./machines/utm-nixos/default.nix

      disko.nixosModules.default
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
