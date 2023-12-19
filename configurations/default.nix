{
  # config,
  nixpkgs
, nixos-generators
, inputs
, home-manager
, vscode-server
, agenix
, nix-flatpak
, disko
, impermanence
, nixos-hardware
, pkgsFor
, ...
} @ attrs:
let
  # base = {
  #   imports = [
  #     # nixos-generators.nixosModules.all-formats
  #     ../common/defaults.nix
  #   ];
  # };
  # base = { config, ... }@attrs: (import ../common/defaults.nix (attrs));
  raspberrypis = (import ./raspberrypi.nix (attrs));
  nonfree = { ... }: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = _: true;
  };
in
raspberrypis // {
  # raspberrypi-3 = raspberrypis.raspberrypi-3;
  # raspbii = raspberrypis.raspbii;
  # inherit raspberrypis;

  live = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      ../installer.nix
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
      inherit inputs; #  nixpkgs;
    };

    # specialArgs = attrs;

    modules = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      # base
      ../common/defaults.nix
      disko.nixosModules.default
      ../machines/enceladus
      ../secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      ../apps/attic.nix
      home-manager.nixosModules.home-manager
      nonfree
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          # nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
      vscode-server.nixosModules.default
      ({ config, pkgs, ... }: { services.vscode-server.enable = true; })
    ];
  };

  supermicro = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    # specialArgs = attrs;

    specialArgs = { inherit inputs nixpkgs; };
    modules = [
      nixos-hardware.nixosModules.common-cpu-intel
      # ./user-defaults.nix
      ../common/defaults.nix
      disko.nixosModules.default
      # impermanence.nixosModules.impermanence
      ../machines/supermicro
      ../secrets
      ../apps/attic.nix
      agenix.nixosModules.default
      nonfree
      ({ lib, ... }: {
        services.tailscale = {
          useRoutingFeatures = lib.mkForce "both";
        };
      })

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          # nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
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
      ../common/defaults.nix
      disko.nixosModules.default
      ../machines/utm-nixos/default.nix
      ../secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      nonfree
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  };

  hyperv-nixos = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      nixos-generators.nixosModules.all-formats
      ../common/defaults.nix
      disko.nixosModules.default
      ../machines/hyperv-nixos
      ../secrets
      agenix.nixosModules.default
      nonfree
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
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
      ../common/defaults.nix
      disko.nixosModules.default
      ../machines/unraidferdorie/default.nix
      ../secrets
      agenix.nixosModules.default
      nonfree
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
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
      nixos-generators.nixosModules.all-formats
      # ./user-defaults.nix
      ../common/defaults.nix
      impermanence.nixosModule
      disko.nixosModules.default
      ../machines/cfserve
      ../secrets
      ../apps/attic.nix
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      nonfree
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
      # vscode-server.nixosModules.default
      # ({ config
      #  , pkgs
      #  , ...
      #  }: { services.vscode-server.enable = true; })
    ];
  };

  unraid = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;

    # specialArgs = { inherit inputs outputs; };
    modules = [
      # ./user-defaults.nix
      ../common/defaults.nix
      # impermanence.nixosModule
      # disko.nixosModules.default
      # ./machines/cfserve
      ../secrets
      nix-flatpak.nixosModules.nix-flatpak
      agenix.nixosModules.default
      ({
        boot.isContainer = true;
      })
      nonfree
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          agenix.homeManagerModules.default
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
      # vscode-server.nixosModules.default
      # ({ config
      #  , pkgs
      #  , ...
      #  }: { services.vscode-server.enable = true; })
    ];
  };

  winrtx = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = attrs;
    modules = [
      nonfree
      inputs.nixos-wsl.nixosModules.wsl
      ../machines/winrtx
    ];
  };

  darwinVM = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    specialArgs = attrs;
    modules = [
      ../common/defaults.nix
      ../machines/utm-nixos/default.nix
      nonfree
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
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  };
}
