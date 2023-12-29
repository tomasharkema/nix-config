{
  inputs = {
    nix-netboot-serve.url = "https://flakehub.com/f/DeterminateSystems/nix-netboot-serve/0.1.79.tar.gz";
    nixpkgs.url = "nixpkgs/nixos-23.11";
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # colmena.url = "github:zhaofengli/colmena";
    # colmena.inputs.nixpkgs.follows = "nixpkgs";

    # anywhere.url = "github:nix-community/nixos-anywhere";

    flake-utils.url = "github:numtide/flake-utils";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixvim.url = "github:pta2002/nixvim/nixos-23.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center.url = "github:vlinkz/nix-software-center";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    nix-cache-watcher = {
      url = "git+https://git.sr.ht/~thatonelutenist/nix-cache-watcher?ref=trunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tailscale-prometheus-sd = { url = "github:madjam002/tailscale-prometheus-sd"; };

    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    # nix-gui = {
    #   url = "github:nix-gui/nix-gui";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    #   inputs.rnix-lsp.follows = "rnix-lsp";
    # };
    # rnix-lsp = {
    #   url = "github:nix-community/rnix-lsp";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-checker = {
      url = "https://flakehub.com/f/DeterminateSystems/flake-checker/0.1.17.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*.tar.gz";
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];
    extra-substituters = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/tomas"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    access-tokens = ["github.com=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"];

    keep-outputs = true;
    keep-derivations = true;
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      # You must pass in both your flake's inputs and the root directory of
      # your flake.
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
      channels-config = {
        allowUnfree = true;
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

      # overlays = with inputs; [attic.overlays.default];

      systems.modules.nixos = with inputs; [
        impermanence.nixosModule
        disko.nixosModules.default
        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        # nixos-generators.nixosModules.all-formats
        {
          system.stateVersion = "23.11";
        }
      ];

      homes.modules = with inputs; [
        # agenix.homeManagerModules.default
      ];

      deploy = lib.mkDeploy {inherit (inputs) self;};

      checks =
        builtins.mapAttrs
        (system: deploy-lib:
          deploy-lib.deployChecks inputs.self.deploy)
        inputs.deploy-rs.lib;

      outputs-builder = channels:
      # let
      # derp = builtins.trace ">>> channels format: ${lib.attrsToList channels}";
      # in
      # derp
      {
        formatter = channels.nixpkgs.alejandra;

        images = with inputs; {
          baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
          pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;

          #   arthuriso = self.nixosConfigurations.arthur.config.formats.install-iso;

          #   silver-star-ferdorie = self.nixosConfigurations.silver-star-ferdorie.config.formats.qcow;

          #   hyperv-installiso =
          #     self.nixosConfigurations.hyperv-nixos.config.formats.qcow;
        };
      };
    };

  # outputs = {
  #   self,
  #   nixpkgs,
  #   nixos-generators,
  #   deploy,
  #   home-manager,
  #   nix,
  #   flake-utils,
  #   anywhere,
  #   agenix,
  #   nix-darwin,
  #   nix-cache-watcher,
  #   alejandra,
  #   attic,
  #   system-manager,
  #   impermanence,
  #   ...
  # } @ inputs: let
  #   inherit (self) outputs;
  #   lib = nixpkgs.lib // home-manager.lib;
  #   systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-linux"];
  #   forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
  #   pkgsFor = lib.genAttrs systems (system:
  #     import nixpkgs {
  #       inherit system;
  #       config.allowUnfree = true;
  #     });
  #   home = {
  #     home-manager.useGlobalPkgs = true;
  #     home-manager.useUserPackages = true;
  #     home-manager.extraSpecialArgs = {
  #       inherit inputs;
  #     };
  #     home-manager.users.tomas.imports = [agenix.homeManagerModules.default ./home.nix];
  #     home-manager.backupFileExtension = "bak";
  #   };
  # in
  #   {
  #     nixpkgs.config.allowUnfree = true;
  #     nixpkgs.config.allowUnfreePredicate = _: true;
  #     nixpkgs.overlays = [(import ./apps/atuin/overlay.nix) (import ./apps/direnv.nix)];

  #     #      colmena = import ./colmena.nix (inputs // { inherit inputs; });

  #     nixosModules = {
  #     };

  #     nixosConfigurations = import ./configurations {inherit inputs nixpkgs;};

  #     darwinConfigurations = import ./configurations/darwin.nix {inherit inputs lib;};

  #     homeConfigurations = {
  #       "root@silver-star" = home-manager.lib.homeManagerConfiguration {
  #         extraSpecialArgs = {inherit inputs;};

  #         modules = [
  #           agenix.homeManagerModules.default
  #           ./machines/silver-star
  #           ./home.nix
  #         ];
  #       };
  #     };

  #     # systemConfigs.silver-star = system-manager.lib.makeSystemConfig {
  #     #   modules = [
  #     #     # impermanence.nixosModules.impermanence
  #     #     ./machines/silver-star
  #     #     home-manager.nixosModules.home-manager
  #     #     {
  #     #       home-manager.useGlobalPkgs = true;
  #     #       home-manager.useUserPackages = true;
  #     #       home-manager.extraSpecialArgs = { inherit inputs; };
  #     #       home-manager.users.tomas.imports = [
  #     #         # nix-flatpak.homeManagerModules.nix-flatpak
  #     #         agenix.homeManagerModules.default
  #     #         ./home.nix
  #     #         {
  #     #           home.username = "root";
  #     #           home.homeDirectory = "/root";
  #     #         }
  #     #       ];
  #     #       home-manager.backupFileExtension = "bak";
  #     #     }
  #     #   ];
  #     # };

  #     deploy = {
  #       nodes = {
  #         pegasus = {
  #           hostname = "192.168.178.93";
  #           # hostname = "172.25.220.155";
  #           # hostname = "100.66.126.23";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.aarch64-linux.activate.nixos
  #               self.nixosConfigurations.pegasus;
  #           };
  #         };
  #         baaa-express = {
  #           hostname = "172.25.240.89";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.aarch64-linux.activate.nixos
  #               self.nixosConfigurations.baaa-express;
  #           };
  #         };

  #         silver-star = {
  #           hostname = "100.122.146.5";
  #           profiles.user = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.home-manager
  #               self.homeConfigurations."root@silver-star";
  #           };
  #         };
  #         enzian = {
  #           hostname = "100.78.63.10";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.enzian;
  #           };
  #         };
  #         silver-star-ferdorie = {
  #           hostname = "100.89.172.46";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.silver-star-ferdorie;
  #           };
  #         };
  #         utm-nixos = {
  #           hostname = "100.124.108.91";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.aarch64-linux.activate.nixos
  #               self.nixosConfigurations.utm-nixos;
  #           };
  #         };
  #         hyperv-nixos = {
  #           hostname = "172.25.240.242";
  #           # hostname = "192.168.1.74";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.hyperv-nixos;
  #           };
  #         };
  #         blue-fire = {
  #           # hostname = "172.25.172.112";
  #           # hostname = "192.168.1.77";
  #           hostname = "100.65.162.126";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.blue-fire;
  #           };
  #         };
  #         arthur = {
  #           hostname = "100.70.39.116";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.arthur;
  #           };
  #         };
  #         wodan-wsl = {
  #           hostname = "172.25.59.229";
  #           profiles.system = {
  #             user = "root";
  #             sshUser = "root";
  #             path =
  #               deploy.lib.x86_64-linux.activate.nixos
  #               self.nixosConfigurations.wodan-wsl;
  #           };
  #         };
  #       };
  #     };

  #     checks =
  #       builtins.mapAttrs
  #       (system: deployLib: deployLib.deployChecks self.deploy)
  #       deploy.lib;

  #     hydraJobs = {
  #       inherit
  #         (self)
  #         packages
  #         ;
  #     };
  #     # packages = { self, flake-utils, ... }:
  #     #   flake-utils.lib.eachDefaultSystem (system:
  #     #     {

  #     #     });

  #     # packages.aarch64-darwin = {
  #     #   darwinVM = self.nixosConfigurations.darwinVM.config.system.build.vm;
  #     #   installiso = self.packages.default.installiso;
  #     # };
  #     #   #     utmiso = nixos-generators.nixosGenerate {
  #     #   #       # inherit nixpkgs pkgs;
  #     #   #       system = "aarch64-linux";
  #     #   #       specialArgs = inputs;
  #     #   #       modules = [
  #     #   #         self.nixosConfigurations.utm-nixos.config
  #     #   #         # ({ pkgs, ... }: { })
  #     #   #       ];
  #     #   #       format = "qcow";
  #     #   #     };
  #     #   enzianiso = nixos-generators.nixosGenerate {
  #     #     system = "x86_64-linux";
  #     #     # specialArgs = inputs;
  #     #     pkgs = pkgsFor.x86_64-linux;

  #     #     specialArgs = { inherit inputs outputs; };
  #     #     modules = [ self.nixosConfigurations.enzian.config ];
  #     #     format = "install-iso";
  #     #   };
  #     # };

  #     #  let system = "x86_64-linux"; pkgs = pkgsFor.x86_64-linux; in nixos-generators.nixosGenerate {
  #     #   system = system;
  #     #   # specialArgs = inputs;
  #     #   pkgs = pkgs;

  #     #   specialArgs = { inherit inputs pkgs; };
  #     #   modules = [ self.nixosConfigurations.arthur.config ];
  #     #   format = "install-iso";
  #     # };
  #   }
  #   // inputs.flake-utils.lib.eachDefaultSystem (system: let
  #     pkgs = import inputs.nixpkgs {inherit system;};
  #     rundesk = import ./rundesk {
  #       inherit pkgs lib;
  #     };
  #   in {
  #     formatter = alejandra.defaultPackage.${system};

  #     packages = {
  #       tailscaled = import ./apps/tailscale/tailscaled.nix {
  #         inherit pkgs lib;
  #       };
  #       # darwinVM = self.nixosConfigurations.darwinVM.config.system.build.vm;
  #       darwinBuilder = self.darwinConfigurations.builder;

  #       installiso =
  #         self.nixosConfigurations.live.config.system.build.isoImage;

  #       hyperv-installiso =
  #         self.nixosConfigurations.hyperv-nixos.config.system.build.isoImage;

  #       netboot =
  #         self.nixosConfigurations.netboot.config.system.build.toplevel;

  #       # attic = import ./attic/attic.nix {
  #       #   inherit attic;
  #       #   pkgsLinux = pkgsFor."x86_64-linux";
  #       # };

  #       rundesk = rundesk.runner;

  #       inherit (rundesk) run-imager;

  #       # enzian = self.nixosConfigurations.enzian.config.system.build.toplevel;
  #     };

  #     devShells = {
  #       default = import ./shell.nix {
  #         inherit inputs;
  #         inherit pkgs;
  #         inherit nixpkgs;
  #       };
  #       rundesk =
  #         (import ./rundesk {
  #           inherit pkgs lib;
  #         })
  #         .shell;
  #     };
  #   });
}
