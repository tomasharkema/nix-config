{
  nixpkgs,
  nixos-generators,
  inputs,
  home-manager,
  vscode-server,
  agenix,
  # nix-flatpak,
  nix-index-database,
  disko,
  impermanence,
  nixos-hardware,
  pkgsFor,
  ...
} @ attrs: let
  # base = {
  #   imports = [
  #     # nixos-generators.nixosModules.all-formats
  #     ../common/defaults.nix
  #   ];
  # };
  # base = { config, ... }@attrs: (import ../common/defaults.nix (attrs));
  nonfree = _: {
    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = _: true;
  };
  homemanager = [
    nix-index-database.hmModules.nix-index
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {inherit inputs;};
      home-manager.users.tomas.imports = [
        agenix.homeManagerModules.default
        ../home.nix
      ];
      home-manager.backupFileExtension = "bak";
    }
  ];
  raspberrypis = import ./raspberrypi.nix (attrs // {inherit homemanager;}); # // { inherit homemanager; }));
in
  raspberrypis
  // {
    # raspberrypi-3 = raspberrypis.raspberrypi-3;
    # pegasus = raspberrypis.pegasus;
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
        ({
          config,
          pkgs,
          lib,
          modulesPath,
          ...
        }: {
          imports = [(modulesPath + "/installer/netboot/netboot-minimal.nix")];
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

    enzian = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs; #  nixpkgs;
      };

      # specialArgs = attrs;

      modules =
        [
          ../common/wifi_module.nix
          inputs.nixos-hardware.nixosModules.common-cpu-intel
          inputs.nixos-hardware.nixosModules.common-pc-ssd
          # base
          ../common/defaults.nix
          disko.nixosModules.default
          ../machines/enzian
          ../secrets
          # nix-flatpak.nixosModules.nix-flatpak
          agenix.nixosModules.default
          ../apps/attic.nix
          nonfree
          vscode-server.nixosModules.default
          ({
            config,
            pkgs,
            ...
          }: {services.vscode-server.enable = true;})
        ]
        ++ homemanager;
    };

    blue-fire = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # specialArgs = attrs;

      specialArgs = {inherit inputs;};
      modules =
        [
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          # nixos-hardware.nixosModules.common-cpu-intel
          # nixos-hardware.nixosModules.common-pc-ssd
          # ./user-defaults.nix
          ../common/defaults.nix
          disko.nixosModules.default
          # impermanence.nixosModules.impermanence
          ../machines/blue-fire
          ../secrets
          ../apps/attic.nix
          agenix.nixosModules.default
          nonfree
          ({lib, ...}: {
            services.tailscale = {
              useRoutingFeatures = lib.mkForce "both";
            };
          })
        ]
        ++ homemanager;
    };

    utm-nixos = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      # specialArgs = { inherit inputs outputs; };
      modules =
        [
          ../common/defaults.nix
          disko.nixosModules.default
          ../machines/utm-nixos/default.nix
          ../secrets
          agenix.nixosModules.default
          nonfree
        ]
        ++ homemanager;
    };

    hyperv-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules =
        [
          nixos-generators.nixosModules.all-formats
          ../common/defaults.nix
          disko.nixosModules.default
          ../machines/hyperv-nixos
          ../secrets
          agenix.nixosModules.default
          nonfree
        ]
        ++ homemanager;
    };

    silver-starferdorie = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # specialArgs = attrs;
      specialArgs = {inherit inputs;};

      modules =
        [
          nixos-generators.nixosModules.all-formats
          ../common/defaults.nix
          disko.nixosModules.default
          ../machines/silver-starferdorie
          ../secrets
          agenix.nixosModules.default
          nonfree
        ]
        ++ homemanager;
    };

    arthur = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;

      # specialArgs = { inherit inputs outputs; };
      modules =
        [
          nixos-generators.nixosModules.all-formats

          "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-ssd

          ../common/defaults.nix
          impermanence.nixosModule
          disko.nixosModules.default
          ../machines/arthur
          ../secrets
          ../apps/attic.nix
          # nix-flatpak.nixosModules.nix-flatpak
          agenix.nixosModules.default
          nonfree
          # vscode-server.nixosModules.default
          # ({ config
          #  , pkgs
          #  , ...
          #  }: { services.vscode-server.enable = true; })
        ]
        ++ homemanager;
    };

    silver-star = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;

      # specialArgs = { inherit inputs outputs; };
      modules =
        [
          # ./user-defaults.nix
          ../common/defaults.nix
          # impermanence.nixosModule
          # disko.nixosModules.default
          # ./machines/arthur
          ../secrets
          # nix-flatpak.nixosModules.nix-flatpak
          agenix.nixosModules.default
          {
            boot.isContainer = true;
          }
          nonfree

          # vscode-server.nixosModules.default
          # ({ config
          #  , pkgs
          #  , ...
          #  }: { services.vscode-server.enable = true; })
        ]
        ++ homemanager;
    };

    wodan-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = attrs;
      modules =
        [
          nonfree
          agenix.nixosModules.default
          ../common/defaults.nix
          ../secrets
          inputs.nixos-wsl.nixosModules.wsl
          ../machines/wodan
        ]
        ++ homemanager;
    };

    darwinVM = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = attrs;
      modules =
        [
          ../common/defaults.nix
          ../machines/utm-nixos/default.nix
          nonfree
          disko.nixosModules.default
          # nix-flatpak.nixosModules.nix-flatpak
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
        ]
        ++ homemanager;
    };
  }
