{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    # nixpkgs-nvidia = nixpkgs;

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    systems.url = "github:nix-systems/default";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = {
        systems.follows = "systems";
      };
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-anywhere = {
      url = "github:nix-community/nixos-anywhere";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
        flake-parts.follows = "flake-parts";
      };
    };

    # vscode-server = {
    #   url = "github:nix-community/nixos-vscode-server";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "darwin";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "darwin";
        systems.follows = "systems";
      };
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";

      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # cachix-deploy-flake = {
    #   url = "github:cachix/cachix-deploy-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-conf-editor = {
    #   url = "github:snowfallorg/nixos-conf-editor";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";

      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        crane.follows = "crane";
        flake-parts.follows = "flake-parts";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        snowfall-lib.follows = "snowfall-lib";
      };
    };

    # peerix = {
    #   url = "github:cid-chan/peerix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    # stylix = {
    #   url = "github:danth/stylix/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-search = {
      url = "github:NixOS/nixos-search";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # command-center = {
    #   url = "github:tomasharkema/command-center";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # filestash-nix = {
    #   url = "github:matthewcroughan/filestash-nix";
    #   inputs.nixpkgs.follows = "unstable";
    # };

    # zjstatus = {
    #   url = "github:dj95/zjstatus";
    # };

    # tree-sitter-nix = {
    #   url = "github:nix-community/tree-sitter-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-checkmk = {
      url = "github:tomasharkema/nixos-checkmk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    _1password-shell-plugins = {
      url = "github:1Password/shell-plugins";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-service = {
      url = "github:tomasharkema/nixos-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-virt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;

      src = ./.;

      imports = [
        inputs.agenix-rekey.flakeModule
      ];

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

      # src = ./.;

      channels-config = {
        allowUnfreePredicate = _: true;
        allowUnfree = true;

        firefox.enableGnomeExtensions = true;
        kodi.enableAdvancedLauncher = true;
        # allowBroken = true;
        nvidia.acceptLicense = true;
        cudaSupport = builtins.break true;
        # allowAliases = false;

        # config.allowUnsupportedSystem = true;
        # hostPlatform.system = "aarch64-linux";
        # buildPlatform.system = "x86_64-linux";
        # permittedInsecurePackages = [ "openssl-1.1.1w" ];
        config = {
          # For example, enable smartcard support in Firefox.
          firefox.smartcardSupport = true;
        };
      };

      # alias = { shells = { default = "devshell"; }; };

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
        nixos-checkmk.overlays.default
        nixos-service.overlays.default
      ];

      system.modules.darwin = with inputs; [
        {
          system.nixos.tags = ["snowfall"];
          system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
        }
      ];

      homes.modules = with inputs; [
        #     catppuccin.homeManagerModules.catppuccin
        nixvim.homeManagerModules.nixvim

        nix-index-database.hmModules.nix-index

        _1password-shell-plugins.hmModules.default
      ];

      systems.modules.nixos = with inputs; [
        nixos-checkmk.nixosModules.check_mk_agent

        catppuccin.nixosModules.catppuccin

        # attic.nixosModules.atticd
        # peerix.nixosModules.peerix

        # impermanence.nixosModule
        disko.nixosModules.default
        # nh.nixosModules.default
        lanzaboote.nixosModules.lanzaboote
        # vscode-server.nixosModules.default

        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default

        nix-gaming.nixosModules.pipewireLowLatency
        nix-gaming.nixosModules.platformOptimizations

        nixos-service.nixosModules.nixos-service
        nix-virt.nixosModules.default

        {
          config = {
            system.stateVersion = "24.05";
            system.nixos.tags = [
              "snowfall"
              (self.shortRev or "dirty")
            ];
            system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
            nix = {
              registry.nixpkgs.flake = inputs.nixpkgs;
              registry.home-manager.flake = inputs.home-manager;
              # registry.unstable.flake = inputs.unstable;
              registry.darwin.flake = inputs.darwin;
            };
          };
        }
      ];

      deploy = lib.mkDeploy {
        inherit (inputs) self;

        # overrides = {
        #   sshUser = "root";
        #   # wodan-vm = {
        #   #   hostname = "192.168.1.74";
        #   # };
        #   # wodan-wsl = {
        #   #   sshUser = "root";
        #   #   hostname = "192.168.1.42";
        #   # };
        #   euro-mir-vm = {
        #     sshUser = "root";
        #     hostname = "172.25.255.212";
        #   };
        #   schweizer-bobbahn = {
        #     hostnamw = "schweizer-bobbahn.local";
        #     # targetHost = "192.168.178.46";
        #     sshUser = "root";
        #   };
        # };
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
          specialArgs = {
            inherit inputs;
          };
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./installer.nix
            (
              {
                lib,
                pkgs,
                ...
              }: {
                boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
              }
            )
          ];
        };

        installer-arm = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            ./installer.nix
            (
              {
                lib,
                pkgs,
                ...
              }: {
                boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
              }
            )
          ];
        };
        installer-arm-img = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
            ./installer.nix
            (
              {
                lib,
                pkgs,
                ...
              }: {
                boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
              }
            )
          ];
        };
      };

      servers = with inputs; let
        names = builtins.attrNames self.nixosConfigurations;
      in
        builtins.filter (
          name: self.nixosConfigurations."${name}".config.networking.hostName != "nixos"
        )
        names;

      images = with inputs; rec {
        # baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        # pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;
        installer-x86 = self.nixosConfigurations.installer-x86.config.system.build.isoImage;
        installer-arm = self.nixosConfigurations.installer-arm.config.system.build.isoImage;

        installer-arm-img = self.nixosConfigurations.installer-arm-img.config.system.build.sdImage;

        # services = let
        #   config = "pegasus";
        #   tryHasAttr = path: value: attr:
        #     let v = builtins.tryEval (lib.attrsets.hasAttrByPath path attr);
        #     in builtins.trace "${builtins.toJSON path} ${
        #       builtins.toJSON (builtins.tryEval (builtins.toJSON attr))
        #     } ${builtins.toJSON v}" (v.success && v.value == value);
        #   serviceNames = builtins.attrNames
        #     self.nixosConfigurations."${config}".config.services;
        # in builtins.filter (n:
        #   tryHasAttr [ n "enable" ] true
        #   self.nixosConfigurations."${config}".config.services) serviceNames;

        # servicesJson = builtins.toJSON services;

        # lib.attrsets.filterAttrs (n: v: (builtins.hasAttr "enable" n) && n.enable) self.nixosConfigurations.pegasus.config.services;
      };

      # formatter = inputs.nixpkgs.nixfmt;
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
    trusted-users = [
      "root"
      "tomas"
    ];
    # netrc-file = "/etc/nix/netrc";

    # trustedBinaryCaches = ["https://cache.nixos.org"];
    # binaryCaches = ["https://cache.nixos.org"];

    substituters = [
      "https://cache.nixos.org/"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-cache.harke.ma/tomas/"
      "https://devenv.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];

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
