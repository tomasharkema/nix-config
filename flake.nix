{
  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;

      imports = [inputs.agenix-rekey.flakeModule];

      # src = builtins.path {
      #   path = ./.;
      #   name = "snowfall-flake-source";
      # };
      src = ./.;
      # src = inputs.self;

      channels-config = {
        allowUnfreePredicate = _: true;
        allowUnfree = true;
        segger-jlink.acceptLicense = true;

        # firefox.enableGnomeExtensions = true;
        # firefox.smartcardSupport = true;
        kodi.enableAdvancedLauncher = true;
        # allowBroken = true;
        nvidia.acceptLicense = true;
        cudaSupport = false;

        allowAliases = true;

        config.allowAliases = true;
        # lazy-trees = true;

        # config.allowUnsupportedSystem = true;
        # hostPlatform.system = "aarch64-linux";
        # buildPlatform.system = "x86_64-linux";

        permittedInsecurePackages = [
          # "python3.12-youtube-dl-2021.12.17"
          # "openssl-1.1.1w"
          "dotnet-sdk-6.0.428"
          # "python-2.7.18.8"
          #"netbox-4.2.9"
          "segger-jlink-qt4-824"
          "segger-jlink-qt4-874"
          "dotnet-runtime-6.0.36"
          "libsoup-2.74.3"
          "python3.13-ecdsa-0.19.1"
        ];
        enableBroken = true;
        config = {
          allowUnfreePredicate = _: true;
          allowUnfree = true;
          cudaSupport = false;
          enableBroken = true;
          # contentAddressedByDefault = true;
          # For example, enable smartcard support in Firefox.
          # firefox.smartcardSupport = true;
          #lazy-trees = true;
          permittedInsecurePackages = [
            # "openssl-1.1.1w"
            # "python3.12-youtube-dl-2021.12.17"
            # "python-2.7.18.8"
          ];
        };
      };

      # alias = { shells = { default = "devshell"; }; };

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";

        user = {
          enable = true;
          name = "tomas";
        };
      };

      overlays = with inputs; [
        # nix-snapshotter.overlays.default
        # otel.overlays.default
        nvidia-patch.overlays.default
        nixos-recovery.overlays.recovery
        # peerix.overlay
        snowfall-flake.overlays."package/flake"
        # nixos-checkmk.overlays.default
        # nixos-service.overlays.default
        agenix-rekey.overlays.default
        nixvim.overlays.default
        # nix-topology.overlays.default
        # opentelemetry-nix.overlays.default
        nixpkgs-esp-dev.overlays.default
        niri.overlays.niri
        nur-xddxdd.overlays.default
        nix-cachyos-kernel.overlays.pinned
      ];

      homes.modules = with inputs; [
        # catppuccin.homeManagerModules.catppuccin
        nixvim.homeModules.nixvim
        nix-index-database.homeModules.nix-index
        op-shell-plugins.hmModules.default
        catppuccin.homeModules.catppuccin
        # agenix.homeManagerModules.default
        # hyprpanel.homeManagerModules.hyprpanel
        # walker.homeManagerModules.default
        # niri.homeModules.niri
        dankMaterialShell.homeModules.dankMaterialShell.default
        # dankMaterialShell.homeModules.dankMaterialShell.niri
        # dsearch.homeModules.default
      ];

      # systems.hosts = let
      #   cudaOff = {...}: {
      #     nixpkgs = {
      #       config = {
      #         cudaSupport = false;
      #       };
      #     };
      #   };
      # in {
      #   euro-mir-vm.modules = [cudaOff];
      #   pegasus.modules = [cudaOff];
      # };

      systems.modules = {
        nixos = with inputs; [
          # comin.nixosModules.comin
          # nixos-vfio.nixosModules.default
          # nix-snapshotter.nixosModules.default
          nix-flatpak.nixosModules.nix-flatpak
          nixos-facter-modules.nixosModules.facter
          # nix-topology.nixosModules.default
          # netkit.nixosModule
          # nixos-checkmk.nixosModules.check_mk_agent
          nixos-recovery.nixosModules.recovery
          catppuccin.nixosModules.catppuccin
          # peerix.nixosModules.peerix
          tsnsrv.nixosModules.default
          # impermanence.nixosModule
          disko.nixosModules.default

          lanzaboote.nixosModules.lanzaboote
          # lanzaboote.nixosModules.uki
          # vscode-server.nixosModules.default
          niri.nixosModules.niri
          # home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default

          # nix-gaming.nixosModules.pipewireLowLatency
          # nix-gaming.nixosModules.wine
          # nix-gaming.nixosModules.platformOptimizations
          # walker.nixosModules.default

          vscode-server.nixosModules.default
          # nvidia-vgpu-nixos.nixosModules.guest
          # nixos-service.nixosModules.nixos-service
          # nix-virt.nixosModules.default
          dankMaterialShell.nixosModules.greeter

          nixos-cli.nixosModules.nixos-cli

          ./defaultNixosAge.nix
          (
            {config, ...}: {
              nix = {
                extraOptions = ''
                  !include ${config.age.secrets.nix-access-tokens-github.path}
                '';
                nixPath = let path = toString ./.; in ["repl=${path}/repl.nix" "nixpkgs=${inputs.nixpkgs}"];
              };
            }
          )
        ];

        darwin = with inputs; [
          agenix.darwinModules.default
          agenix-rekey.nixosModules.default
          # mac-app-util.darwinModules.default

          (
            {
              config,
              lib,
              ...
            }: {
              config = {
                # nm-overrides.desktop.home-exec.enable = false;

                # system.nixos.tags = ["snowfall"];
                system.configurationRevision = lib.mkForce (self.shortRev or "dirty");
                # nixpkgs.flake.setFlakeRegistry = false;
                # nixpkgs.flake.setNixPath = false;

                nix = {
                  extraOptions = ''
                    !include ${config.age.secrets.nix-access-tokens-github.path}
                  '';

                  # settings.extra-sandbox-paths = ["/tmp/agenix-rekey.${builtins.toString config.users.users."${config.user.name}".uid}"];
                };

                age = {
                  secrets = {
                    nix-access-tokens-github.rekeyFile = ./secrets/github.age;
                  };

                  rekey = {
                    masterIdentities = [./secrets/age-yubikey-identity-usbc.pub];

                    # extraEncryptionPubkeys = [
                    #   ./secrets/age-yubikey-identity-usba.pub
                    # ];

                    storageMode = "local";
                    localStorageDir = ./. + "/secrets/rekeyed/${config.networking.hostName}";
                  };
                };
              };
            }
          )
        ];
      };
      flakeInputs = inputs;

      agenix-rekey = let
        lib = inputs.nixpkgs.lib;
      in
        inputs.agenix-rekey.configure {
          userFlake = inputs.self;
          nixosConfigurations = lib.attrsets.filterAttrs (n: v: (!(lib.strings.hasPrefix "installer" n))) (
            inputs.self.nixosConfigurations // inputs.self.darwinConfigurations
          );
          # Example for colmena:
          # inherit ((colmena.lib.makeHive self.colmena).introspect (x: x)) nodes;
        };

      machines = let
        names = builtins.attrNames (builtins.readDir ./systems-by-name);
      in rec {
        all =
          names;

        excludingSelf = cfg: (builtins.filter (name: cfg.networking.hostName != name) all);
      };

      images = with inputs; {
        # baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        # pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;
        installer = {
          iso = {
            "x86_64-linux" = self.installer."x86_64-linux".iso.config.system.build.isoImage;
            "aarch64-linux" = self.installer."aarch64-linux".iso.config.system.build.isoImage;
          };
          img = let
            config = self.installer."aarch64-linux".img.config;
          in {
            inherit config;
            "aarch64-linux" = config.system.build.sdImage;
          };
        };

        linuxKernel_x86 = self.nixosConfigurations.wodan.config.boot.kernelPackages.kernel;

        linuxKernel_arm = self.nixosConfigurations.euro-mir-vm.config.boot.kernelPackages.kernel;

        all = self.pkgs."x86_64-linux".nixpkgs.mkShell {
          buildInputs = let
            names = [
              "wodan"
              "blue-fire"
              "enceladus"
              "voltron"
              "enzian"
              "sura"
              "pegasus"
              "coopi"
            ];
          in
            builtins.map (n: self.nixosConfigurations."${n}".config.system.build.toplevel) names;
        };

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

      checks = inputs.self.images.installer.iso;

      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;

        # checks = let
        #   nixosMachines = lib.mapAttrs' (
        #     name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel
        #   ) ((lib.filterAttrs (_: config: config.pkgs.system == system)) inputs.self.nixosConfigurations);
        #   packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
        #     inputs.self.packages."${system}"
        #   );
        # in
        #   nixosMachines // packages;

        # topology = import inputs.nix-topology {
        #   inherit pkgs;
        #   modules = [
        #     # Your own file to define global topology. Works in principle like a nixos module but uses different options.
        #     # ./topology.nix
        #     # Inline module to inform topology of your existing NixOS hosts.
        #     {nixosConfigurations = inputs.self.nixosConfigurations;}
        #   ];
        # };

        installer = import ./installer {
          inherit channels;
          inherit inputs;
        };

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
    #  ca-derivations recursive-nix
    extra-experimental-features = "nix-command flakes cgroups"; # ca-derivations";
    experimental-features = "nix-command flakes cgroups"; # ca-derivations";
    distributedBuilds = true;
    builders-use-substitutes = true;
    lazy-trees = true;
    trusted-users = [
      "root"
      "tomas"
      # "${config.user.name}"
    ];
    connect-timeout = 5;
    # allow-unsafe-native-code-during-evaluation = true;

    # netrc-file = "/etc/nix/netrc";

    substituters = [
      "https://cache.nixos.org/"
      # "https://nix-cache.ling-lizard.ts.net/tomasharkema"
      "https://watersucks.cachix.org"
      "https://nixpkgs.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://cuda-maintainers.cachix.org"
      # "https://tomasharkema.cachix.org"
      "http://silver-star.ling-lizard.ts.net:7124"
      "https://niri.cachix.org"
      "https://cache.garnix.io"
      "https://attic.xuyh0120.win/lantian"
      "https://nixos-raspberrypi.cachix.org"
    ];

    # trustedBinaryCaches = [
    #   "https://cache.nixos.org"
    #   "https://nix-gaming.cachix.org"
    #   "https://nix-community.cachix.org"
    #   # "https://nix-cache.ling-lizard.ts.net/tomasharkema"
    #   "https://devenv.cachix.org"
    #   "http://silver-star.ling-lizard.ts.net:7124/tomasharkema"
    #   "https://cuda-maintainers.cachix.org"
    # ];

    # binaryCaches = [
    #   "https://cache.nixos.org"
    #   "https://nix-gaming.cachix.org"
    #   "https://nix-community.cachix.org"
    #   "https://devenv.cachix.org"
    #   "https://cuda-maintainers.cachix.org"
    #   "http://silver-star.ling-lizard.ts.net:7124/tomasharkema"
    #   # "https://nix-cache.ling-lizard.ts.net/tomasharkema"
    # ];

    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "tomasharkema:4Ou4kbViWV9ZPL5DGQZ5j4IEwpQrJ/u9YnU/7oY9djE="
      "watersucks.cachix.org-1:6gadPC5R8iLWQ3EUtfu3GFrVY7X6I4Fwz/ihW25Jbv8="
      "raspi5.harkema.io-1:/kwt4HGmzEnXtQ2i8LMnfu8PrFaiX+oT7z5jsA3sXhs="
      "cm5-1.harkema.io:YFuMMxT3+o9cRQBLnzHaR4xXQwQ4lthh5bDQiAixxFQ="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="
      "tomasharkema.cachix.org-1:BV3Sv3qGZ0bcybPFeigwKoxnpj/NBAFYHq9FMO1XgH4="
      "tomasharkema:VdbRcFT6+nuun6sDcTxEQ4M+1dqncDrjqJPCDOJ6mqo="
      "tomasharkema:O7hvvAIoFVjO5giONleXcRE1Og7IDt2DdvAQRg4GCkI="
      "tomasharkema:4Ou4kbViWV9ZPL5DGQZ5j4IEwpQrJ/u9YnU/7oY9djE="
      "raspi5.harkema.io-1:/kwt4HGmzEnXtQ2i8LMnfu8PrFaiX+oT7z5jsA3sXhs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
      "tomas-nixos-1:attQnEt6Gq99mwz5J/h8EVhCpavuB0/z/u0Bt/Mko7E="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];

    # allowed-uris = [
    #   "https://"
    #   "git+https://"
    #   "github:NixOS/"
    #   "github:nixos/"
    #   "github:hercules-ci/"
    #   "github:numtide/"
    #   "github:cachix/"
    #   "github:nix-community/"
    #   "github:snowfallorg/"
    #   "github:edolstra/"
    #   "github:tomasharkema/"
    #   "github:snowfallorg/"
    # ];

    # allow-import-from-derivation = true;
    keep-outputs = true;
    keep-derivations = true;
    accept-flake-config = true;
    # sandbox = false;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # systems.url = "github:nix-systems/default";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # impermanence = {
    #   url = "github:nix-community/impermanence";
    # };

    # flake-utils = {
    #   url = "github:numtide/flake-utils";
    # };

    # flake-parts = {
    #   url = "github:hercules-ci/flake-parts";
    # };

    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    neix.url = "github:Hovirix/neix";
    # pre-commit-hooks-nix = {
    #   url = "github:cachix/pre-commit-hooks.nix";

    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # treefmt-nix = {
    #   url = "github:numtide/treefmt-nix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #   };
    # };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
        # flake-parts.follows = "flake-parts";
        # treefmt-nix.follows = "treefmt-nix";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim"; # /nixos-24.05";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        # home-manager.follows = "home-manager";
        # nix-darwin.follows = "darwin";
        #     # flake-compat.follows = "flake-compat";
        #     # flake-parts.follows = "flake-parts";
        #     # devshell.follows = "devshell";
        #     # treefmt-nix.follows = "treefmt-nix";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "darwin";
        # systems.follows = "systems";
      };
    };

    agenix-rekey = {
      url = "github:oddlama/agenix-rekey";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-utils.follows = "flake-utils";
        # devshell.follows = "devshell";
        # pre-commit-hooks.follows = "pre-commit-hooks-nix";
      };
    };

    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
    };

    # nix-gaming = {
    #   url = "github:fufexan/nix-gaming";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # flake-parts.follows = "flake-parts";
    #   };
    # };

    # nix-software-center = {
    #   url = "github:snowfallorg/nix-software-center";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # utils.follows = "flake-utils";
    #   };
    # };

    # nixos-conf-editor = {
    #   url = "github:snowfallorg/nixos-conf-editor";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    librepods = {
      url = "github:Chrisbattarbee/librepods";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      # url = "github:andre4ik3/lanzaboote?ref=fenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # crane.follows = "crane";
        # flake-parts.follows = "flake-parts";
        # flake-compat.follows = "flake-compat";
        # flake-utils.follows = "flake-utils";
        # pre-commit-hooks-nix.follows = "pre-commit-hooks-nix";
      };
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      # url = "github:anntnzrb/snowfall-lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-compat.follows = "flake-compat";
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
    #   # url = "github:tomasharkema/peerix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # flake-utils.follows = "flake-utils";
    #   };
    # };

    # stylix = {
    #   url = "github:danth/stylix/release-24.05";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-search = {
    #   url = "github:NixOS/nixos-search";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };

    # command-center = {
    #   url = "github:tomasharkema/command-center";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # filestash-nix = {
    #   url = "github:matthewcroughan/filestash-nix";
    #   inputs.nixpkgs.follows = "unstable";
    # };

    # tree-sitter-nix = {
    #   url = "github:nix-community/tree-sitter-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixos-checkmk = {
    #   url = "github:tomasharkema/nixos-checkmk";

    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";

      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # nbfc-linux = {
    # url = "github:nbfc-linux/nbfc-linux";
    # inputs.nixpkgs.follows = "nixpkgs";
    # };

    op-shell-plugins = {
      url = "github:1Password/shell-plugins";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        # flake-utils.follows = "flake-utils";
      };
    };

    # nixos-service = {
    #   url = "github:tomasharkema/nixos-service";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # conky = {
    #   url = "github:brndnmtthws/conky";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # flake-utils.follows = "flake-utils";
    #   };
    # };

    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:tomasharkema/nixos-06cb-009a-fingerprint-sensor/25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-vfio = {
    #   url = "github:j-brn/nixos-vfio";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # netkit = {
    #   url = "github:icebox-nix/netkit.nix";
    # };

    # nix-topology = {
    #   url = "github:oddlama/nix-topology";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # flake-utils.follows = "flake-utils";
    #     # devshell.follows = "devshell";
    #     # pre-commit-hooks.follows = "pre-commit-hooks-nix";
    #   };
    # };

    # nixos-dash-docset = {
    #   url = "github:ptitfred/nixos-dash-docset";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-utils.follows = "flake-utils";
    #   };
    # };
    # opentelemetry-nix = {
    #   url = "github:FriendsOfOpenTelemetry/opentelemetry-nix";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     # flake-utils.follows = "flake-utils";
    #   };
    # };

    nvidia-vgpu-nixos = {
      url = "github:mrzenc/vgpu4nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-htop = {
    #   url = "https://flakehub.com/f/tomasharkema/nix-htop/0.0.*.tar.gz";

    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     flake-parts.follows = "flake-parts";
    #   };
    # };

    nixos-recovery = {
      url = "github:tomasharkema/nixos-recovery/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # nix-mineral = {
    #   url = "github:cynicsketch/nix-mineral";
    #   flake = false;
    # };

    tsui = {
      url = "github:neuralinkcorp/tsui";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = {
        # nixpkgs.follows = "nixpkgs";
      };
    };

    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    piratebay = {
      url = "github:tsirysndr/piratebay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wezterm = {
    #   url = "github:wez/wezterm?dir=nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # otel = {
    #   url = "github:tomasharkema/nix-otel";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nix-snapshotter = {
    #   url = "github:pdtpartners/nix-snapshotter";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # comin = {
    #   url = "github:nlewo/comin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-cachyos-kernel.follows = "nix-cachyos-kernel";
        nix-index-database.follows = "nix-index-database";
      };
    };

    # nixgl = {
    #   url = "github:nix-community/nixGL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    tsnsrv = {
      url = "github:boinkor-net/tsnsrv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixd = {
      url = "github:nix-community/nixd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # wluma = {
    #   url = "github:tomasharkema/wluma";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-esp-dev = {
      url = "github:mirrexagon/nixpkgs-esp-dev/aee1e832fbfef37e14118f83a56def931f2b082f";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell/1db3907838161b309ee034dff1dbcb957e21d36e";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.dgop.follows = "dgop";
      # inputs.dms-cli.follows = "dms-cli";
    };

    # dsearch = {
    #   url = "github:AvengeMedia/danksearch";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nox = {
      url = "github:madsbv/nix-options-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nix-index-database.follows = "nix-index-database";
      };
    };

    nixos-cli = {
      url = "github:nix-community/nixos-cli";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    zsh-colored-man-pages = {
      url = "github:ael-code/zsh-colored-man-pages";
      flake = false;
    };
    zsh-async = {
      url = "github:mafredri/zsh-async";
      flake = false;
    };
    ohmyzsh = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
    zsh-tio = {
      url = "github:JBarberU/zsh-tio";
      flake = false;
    };
    complete-ng = {
      url = "github:joknarf/complete-ng";
      flake = false;
    };
    zsh-tab-title = {
      url = "github:trystan2k/zsh-tab-title";
      flake = false;
    };
    zsh-smartinput = {
      url = "github:momo-lab/zsh-smartinput";
      flake = false;
    };
  };
}
