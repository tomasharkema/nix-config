{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
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
    # inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-shell = {
      url = "github:aciceri/agenix-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
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

    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "unstable";
    };

    devenv = {
      url = "github:cachix/devenv";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-serve-ng = {
      url = "github:aristanetworks/nix-serve-ng";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # peerix = {
    # url = "github:cid-chan/peerix";
    # inputs.nixpkgs.follows = "unstable";
    # };

    # poetry2nix = {
    #   url = "github:nix-community/poetry2nix";
    # };

    # stylix = {
    #   url = "github:danth/stylix/release-23.11";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    command-center = {
      url = "github:tomasharkema/command-center";
      inputs.nixpkgs.follows = "unstable";
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
        allowUnfree = true;
        nvidia.acceptLicense = true;
        firefox.enableGnomeExtensions = true;

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

        nix-serve-ng.nixosModules.default
        attic.nixosModules.atticd
        # peerix.nixosModules.peerix

        # impermanence.nixosModule
        disko.nixosModules.default

        lanzaboote.nixosModules.lanzaboote
        vscode-server.nixosModules.default

        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nixos-generators.nixosModules.all-formats

        {
          system.stateVersion = "23.11";
          system.nixos.tags = ["snowfall"];
          system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
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
          pegasus = {
            hostname = "172.25.220.155";
          };
        };
      };

      checks =
        builtins.mapAttrs
        (system: deploy-lib:
          deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;

      images = with inputs; {
        baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;
      };

      hydraJobs = import ./hydraJobs.nix {inherit inputs;};

      nixosConfigurations = let
        system = "aarch64-darwin";
        pkgs = inputs.nixpkgs.legacyPackages."${system}";
        linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;
      in {
        installer = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ({
              lib,
              pkgs,
              ...
            }: {
              boot.supportedFilesystems = ["bcachefs"];
              boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
            })
          ];
        };
        #   darwin-builder = inputs.nixpkgs.lib.nixosSystem {
        #     system = linuxSystem;
        #     modules = [
        #       "${inputs.nixpkgs}/nixos/modules/profiles/macos-builder.nix"
        #       ./user-defaults.nix
        #       {
        #         # imports = [ ../../apps/tailscale ];
        #         boot.binfmt.emulatedSystems = ["x86_64-linux"];
        #         virtualisation = {
        #           host.pkgs = pkgs;
        #           useNixStoreImage = true;
        #           writableStore = true;
        #           cores = 4;

        #           darwin-builder = {
        #             workingDirectory = "/var/lib/darwin-builder";
        #             diskSize = 64 * 1024;
        #             memorySize = 4096;
        #           };
        #         };

        #         networking.useDHCP = true;
        #         environment.systemPackages = with pkgs; [wget curl cacert];
        #       }
        #     ];
        #   };
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

        # packages.nixos-conf-editor = inputs.nixos-conf-editor.packages.${channels.nixpkgs.system}.nixos-conf-editor;
        # packages.nix-software-center = inputs.nix-software-center.packages.${channels.nixpkgs.system}.nix-software-center;

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

    substituters = [
      "https://nix-community.cachix.org"
      "https://tomasharkema.cachix.org"
      "https://cache.nixos.org/"
      "https://blue-fire.ling-lizard.ts.net/attic/tomas/"
      "https://devenv.cachix.org"
    ];

    trusted-public-keys = [
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
      "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
      "tomas:qzaaV24nfgwcarekICaYr2c9ZBFDQnvvydOywbwAeys="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "tomas:qzaaV24nfgwcarekICaYr2c9ZBFDQnvvydOywbwAeys="
    ];

    # extra-trusted-public-keys = [
    #   "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
    #   "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
    #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #   "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    # ];
    # extra-substituters = [
    #   "https://tomasharkema.cachix.org/"
    #   "https://nix-cache.harke.ma/tomas/"
    #   "https://nix-community.cachix.org/"
    #   "https://cache.nixos.org/"
    #   "https://devenv.cachix.org"
    # ];

    binaryCaches = ["https://cache.nixos.org"];

    allowed-uris = [
      "https://github.com/tomasharkema.keys"
      "https://api.github.com"
      "https://github.com/zhaofengli/nix-base32.git"
      "https://github.com/tomasharkema.keys"
      "https://github.com/NixOS/"
      "https://github.com/nixos/"
      "https://github.com/hercules-ci/"
      "https://github.com/numtide/"
      "https://github.com/cachix/"
      "https://github.com/nix-community/"
      "https://github.com/tomasharkema/"
      "git://github.com/tomasharkema"
      "https://git.sr.ht/~rycee/nmd/archive"
      "https://git.sr.ht/~youkai/nscan"

      "https://api.flakehub.com/f/pinned"
      "https://api.flakehub.com/f/pinned/edolstra/flake-compat"
    ];

    allow-import-from-derivation = true;
    keep-outputs = true;
    keep-derivations = true;
  };
}
