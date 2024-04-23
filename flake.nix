{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";

    # nixpkgs-gnome.url = "nixpkgs/gnome-46";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-wsl = {
    #   url = "github:nix-community/NixOS-WSL";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "unstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
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

    # colmena = {
    #   url = "github:zhaofengli/colmena";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    flake-utils.url = "github:numtide/flake-utils";

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      # inputs.nixpkgs.follows = "unstable";
    };

    nixvim = {
      url = "github:pta2002/nixvim/nixos-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
    };

    agenix-shell = {
      url = "github:aciceri/agenix-shell";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "unstable";
    };
    # cachix-deploy-flake = {
    #   url = "github:cachix/cachix-deploy-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # impermanence.url = "github:nix-community/impermanence";

    attic = {
      url = "github:zhaofengli/attic";
      inputs = {
        nixpkgs.follows = "unstable";
        nixpkgs-stable.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
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

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # peerix = {
    #   url = "github:cid-chan/peerix";
    #   inputs.nixpkgs.follows = "unstable";
    # };

    # poetry2nix = {
    #   url = "github:nix-community/poetry2nix";
    # };

    # stylix = {
    #   url = "github:danth/stylix/release-23.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-search = {
      url = "github:NixOS/nixos-search";
      inputs.nixpkgs.follows = "unstable";
    };

    command-center = {
      url = "github:tomasharkema/command-center";
      inputs.nixpkgs.follows = "unstable";
    };

    # filestash-nix = {
    #   url = "github:matthewcroughan/filestash-nix";
    #   inputs.nixpkgs.follows = "unstable";
    # };

    zjstatus = {
      url = "github:dj95/zjstatus";
    };
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
        allowUnfreePredicate = _: true;
        allowUnfree = true;
        nvidia.acceptLicense = true;
        firefox.enableGnomeExtensions = true;
        kodi.enableAdvancedLauncher = true;
        # allowAliases = false;
        # config.allowUnsupportedSystem = true;
        # hostPlatform.system = "aarch64-linux";
        # buildPlatform.system = "x86_64-linux";
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
        # peerix.overlay
        snowfall-flake.overlays."package/flake"
      ];

      system.modules.darwin = with inputs; [
        {
          system.nixos.tags = ["snowfall"];
          system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
        }
      ];

      systems.modules.nixos = with inputs; [
        nix-index-database.nixosModules.nix-index

        attic.nixosModules.atticd
        # peerix.nixosModules.peerix

        # impermanence.nixosModule
        disko.nixosModules.default

        lanzaboote.nixosModules.lanzaboote
        vscode-server.nixosModules.default

        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nixos-generators.nixosModules.all-formats

        nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations

        {
          system.stateVersion = "23.11";
          system.nixos.tags = ["snowfall" (self.shortRev or "dirty")];
          system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
          nix = {
            registry.nixpkgs.flake = inputs.nixpkgs;
            registry.home-manager.flake = inputs.home-manager;
            registry.unstable.flake = inputs.unstable;
            registry.darwin.flake = inputs.darwin;
          };
        }
      ];

      deploy = lib.mkDeploy {
        inherit (inputs) self;

        overrides = {
          sshUser = "root";
          # wodan-vm = {
          #   hostname = "192.168.1.74";
          # };
          # wodan-wsl = {
          #   sshUser = "root";
          #   hostname = "192.168.1.42";
          # };
          euro-mir-vm = {
            sshUser = "root";
            hostname = "172.25.255.212";
          };
          schweizer-bobbahn = {
            hostnamw = "schweizer-bobbahn.local";
            # targetHost = "192.168.178.46";
            sshUser = "root";
          };
        };
      };

      # checks =
      #   builtins.mapAttrs
      #   (system: deploy-lib:
      #     deploy-lib.deployChecks inputs.self.deploy)
      #   inputs.deploy-rs.lib;

      hydraJobs = import ./hydraJobs.nix {inherit inputs;};

      nixosConfigurations = {
        installer-x86 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./installer.nix
            ({
              lib,
              pkgs,
              ...
            }: {
              boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
            })
          ];
        };

        installer-arm = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ./installer.nix
            ({
              lib,
              pkgs,
              ...
            }: {
              boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
            })
          ];
        };
      };

      images = with inputs; {
        # baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        # pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;
        installer-x86 = self.nixosConfigurations.installer-x86.config.system.build.isoImage;
        installer-arm = self.nixosConfigurations.installer-arm.config.system.build.sdImage;
      };

      # formatter = inputs.nixpkgs.alejandra;
      outputs-builder = channels:
      # let
      #   cachix-deploy-lib = inputs.cachix-deploy-flake.lib channels.nixpkgs;
      # in
      {
        formatter = channels.nixpkgs.alejandra;

        # checks = with inputs; {
        # nixpkgs-lint =
        # inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.nixpkgs-lint ./.;

        # lint = self.packages.${channels.nixpkgs.system}.run-checks;
        # };

        # packages = {
        #   nixos-conf-editor = inputs.nixos-conf-editor.packages.${channels.nixpkgs.system}.nixos-conf-editor;
        #   nix-software-center = inputs.nix-software-center.packages.${channels.nixpkgs.system}.nix-software-center;
        # };
        # defaultPackage = cachix-deploy-lib.spec {
        #   agents = {
        #     blue-fire = inputs.self.nixosConfigurations.blue-fire.config.system.build.toplevel;
        #     blue-fire-slim = inputs.self.nixosConfigurations.blue-fire-slim.config.system.build.toplevel;
        #     enzian = inputs.self.nixosConfigurations.enzian.config.system.build.toplevel;
        #     euro-mir-2 = inputs.self.nixosConfigurations.euro-mir-2.config.system.build.toplevel;
        #     pegasus = inputs.self.nixosConfigurations.pegasus.config.system.build.toplevel;
        #     baaa-express = inputs.self.nixosConfigurations.baaa-express.config.system.build.toplevel;
        #     darwin-builder = inputs.self.nixosConfigurations.darwin-builder.config.system.build.toplevel;
        #     euro-mir-vm = inputs.self.nixosConfigurations.euro-mir-vm.config.system.build.toplevel;
        #   };
        # };
      };
    };

  nixConfig = {
    use-cgroups = true;
    extra-experimental-features = "nix-command flakes cgroups";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];
    # netrc-file = "/etc/nix/netrc";

    substituters = [
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
      "https://blue-fire.ling-lizard.ts.net/attic/tomas/"
      "https://devenv.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "tomas:qzaaV24nfgwcarekICaYr2c9ZBFDQnvvydOywbwAeys="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];

    binaryCaches = ["https://cache.nixos.org"];

    allowed-uris = [
      "https://"
      "git+https://"
      "github:NixOS/"
      "github:nixos/"
      "github:hercules-ci/"
      "github:numtide/"
      "github:cachix/"
      "github:nix-community/"
      "github:snowfallorg/"
      "github:edolstra/"
      "github:tomasharkema/"
      "github:snowfallorg/"
    ];

    allow-import-from-derivation = true;
    keep-outputs = true;
    keep-derivations = true;
    accept-flake-config = true;
  };
}
