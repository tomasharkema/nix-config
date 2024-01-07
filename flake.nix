{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachix-deploy-flake = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fh = {
      url = "github:DeterminateSystems/fh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hydra-check = {
      url = "github:nix-community/hydra-check";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # system-manager = {
    #   url = "github:numtide/system-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # gomod2nix = {
    #   url = "github:nix-community/gomod2nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];

    substituters = [
      "https://tomasharkema.cachix.org/"
      "https://nix-cache.harke.ma/tomas/"
      "https://nix-community.cachix.org/"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
      "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    binaryCaches = ["https://cache.nixos.org"];

    allowed-uris = [
      "https://api.github.com"
      "https://git.sr.ht/~rycee/nmd/archive"
      "https://github.com/zhaofengli/nix-base32.git"
      "https://github.com/tomasharkema.keys"
      "https://api.flakehub.com/f/pinned"
      "https://github.com/NixOS/"
      "https://github.com/nixos/"
      "https://github.com/hercules-ci/"
      "https://github.com/numtide/"
      "https://github.com/cachix/"
      "https://github.com/nix-community/"
      "https://github.com/tomasharkema/"
      "git://github.com/tomasharkema"
    ];

    allow-import-from-derivation = true;
    keep-outputs = true;
    keep-derivations = true;
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";
      };
    };
  in
    lib.mkFlake {
      inherit inputs;

      src = ./.;

      channels-config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };

      alias = {
        shells = {
          default = "devshell";
        };
      };

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      systems.modules.nixos = with inputs; [
        impermanence.nixosModule
        disko.nixosModules.default

        lanzaboote.nixosModules.lanzaboote

        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nixos-generators.nixosModules.all-formats
        {
          system.stateVersion = "23.11";
        }
      ];

      # homes.modules = with inputs; [
      #   # agenix.homeManagerModules.default
      # ];

      deploy = lib.mkDeploy {
        inherit (inputs) self;

        overrides = {
          sshUser = "root";
          wodan-wsl = {
            sshUser = "root";
            hostname = "192.168.1.42";
          };
        };
      };

      # checks =
      #   builtins.mapAttrs
      #   (system: deploy-lib:
      #     deploy-lib.deployChecks inputs.self.deploy)
      #   inputs.deploy-rs.lib;

      images = with inputs; {
        baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;

        arthuriso = self.nixosConfigurations.arthur.config.formats.install-iso;

        # "blue-fire" = self.nixosConfigurations."blue-fire".config.formats.install-iso;
        # "blue-fire-slim" = self.nixosConfigurations."blue-fire-slim".config.formats.install-iso;
      };

      hydraJobs = import ./hydraJobs.nix {inherit inputs;};

      nixosConfigurations = let
        system = "aarch64-darwin";
        pkgs = inputs.nixpkgs.legacyPackages."${system}";
        linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;
      in {
        darwin-builder = inputs.nixpkgs.lib.nixosSystem {
          system = linuxSystem;
          modules = [
            "${inputs.nixpkgs}/nixos/modules/profiles/macos-builder.nix"
            ./user-defaults.nix
            {
              # imports = [ ../../apps/tailscale ];
              boot.binfmt.emulatedSystems = ["x86_64-linux"];
              virtualisation = {
                host.pkgs = pkgs;
                useNixStoreImage = true;
                writableStore = true;
                cores = 4;

                darwin-builder = {
                  workingDirectory = "/var/lib/darwin-builder";
                  diskSize = 64 * 1024;
                  memorySize = 4096;
                };
              };

              networking.useDHCP = true;
              environment.systemPackages = with pkgs; [wget curl cacert];
              services.openssh.enable = true;
            }
          ];
        };
      };

      # formatter = inputs.nixpkgs.alejandra;
      outputs-builder = channels: let
        cachix-deploy-lib = inputs.cachix-deploy-flake.lib channels.nixpkgs;
      in {
        formatter = channels.nixpkgs.alejandra;

        checks = with inputs; {
          # nixpkgs-lint =
          # inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.nixpkgs-lint ./.;

          lint = self.packages.${channels.nixpkgs.system}.run-checks;
        };

        defaultPackage = cachix-deploy-lib.spec {
          agents = {
            blue-fire = inputs.self.nixosConfigurations.blue-fire.config.system.build.toplevel;
            enzian = inputs.self.nixosConfigurations.enzian.config.system.build.toplevel;
            euro-mir-2 = inputs.self.nixosConfigurations.euro-mir-2.config.system.build.toplevel;
            pegasus = inputs.self.nixosConfigurations.pegasus.config.system.build.toplevel;
            baaa-express = inputs.self.nixosConfigurations.baaa-express.config.system.build.toplevel;
            darwin-builder = inputs.self.nixosConfigurations.darwin-builder.config.system.build.toplevel;
          };
        };
      };
    };
}
