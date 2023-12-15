{
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];
    extra-substituters = [
      "https://nix-cache.harke.ma/tomas"
      "https://tomasharkema.cachix.org"
      "https://cache.nixos.org"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/tomas"
      "https://tomasharkema.cachix.org"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    access-tokens = ["github.com=***REMOVED***"];
    # post-build-hook = ./upload-to-cache.sh;
    
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hardware.url = "github:nixos/nixos-hardware";
    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy.url = "github:serokell/deploy-rs";

    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    anywhere.url = "github:nix-community/nixos-anywhere";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixvim.url = "github:pta2002/nixvim/nixos-23.11";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    nix-software-center.url = "github:vlinkz/nix-software-center";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    impermanence.url = "github:nix-community/impermanence";
    nix-cache-watcher.url = "git+https://git.sr.ht/~thatonelutenist/nix-cache-watcher?ref=trunk";
    statix = {
      url = "github:nerdypepper/statix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";

    attic.url = "github:zhaofengli/attic";
    cachix.url = "github:cachix/cachix";

        system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    deploy,
    home-manager,
    nix,
    flake-utils,
    anywhere,
    agenix,
    nix-darwin,
    nix-index-database,
    statix,
    nix-cache-watcher,
    alejandra,
    attic,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-linux"];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
      home =           {
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tomas.imports = [agenix.homeManagerModules.default ./home.nix];
            home-manager.backupFileExtension = "bak";
          };
  in
    {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;

      # colmena = import ./colmena.nix (inputs // { inherit inputs; });

      nixosConfigurations =
        import ./configurations.nix (inputs // {inherit inputs;});

      darwinConfigurations."MacBook-Pro-van-Tomas" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {inherit inputs;};
        modules = [
          # statix.overlays.default
          nix-index-database.darwinModules.nix-index
          agenix.darwinModules.default
          ./secrets
          ({
            pkgs,
            inputs,
            ...
          }: {
            nix.extraOptions = ''
              auto-optimise-store = true
              builders-use-substitutes = true
            '';
            environment.systemPackages = with pkgs; [
              kitty
              terminal-notifier
            ];
            nixpkgs.config.permittedInsecurePackages = [
              "electron-25.9.0"
            ];
            nixpkgs.config.allowUnfree = true;
            services.nix-daemon.enable = true;
            security.pam.enableSudoTouchIdAuth = true;
            users.users.tomas = {
              # isNormalUser = true;
              description = "tomas";
            };
            nix.distributedBuilds = true;

            nix.settings = {
              extra-experimental-features = "nix-command flakes";
              # distributedBuilds = true;
              builders-use-substitutes = true;
              trusted-users = ["root" "tomas"];
              extra-substituters = [
                "https://nix-cache.harke.ma/"
                "https://tomasharkema.cachix.org/"
                "https://cache.nixos.org/"
              ];
              extra-binary-caches = [
                "https://nix-cache.harke.ma/"
                # "https://tomasharkema.cachix.org/"
                "https://cache.nixos.org/"
              ];
              trusted-public-keys = [
                "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
                "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
                "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              ];
              access-tokens = ["github.com=***REMOVED***"];
            };
          })
          home-manager.darwinModules.home-manager
          # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas".config
          # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas"
          # {
          #   imports = [ self.homeConfigurations."tomas@MacBook-Pro-van-Tomas".config ];
          # }
          # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas"
          {
            # home-manager.useGlobalPkgs = true;
            # home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tomas.imports = [agenix.homeManagerModules.default ./home.nix];
            home-manager.backupFileExtension = "bak";
          }
        ];
      };

      homeConfigurations =  {
          "root@tower" = home-manager.lib.homeManagerConfiguration { 
            # system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages."x86_64-linux";
            
    extraSpecialArgs = {
      inherit inputs; 
      username = "root";
      homeDirectory = "/root";
    };
            modules = [ 
              # home 
              agenix.homeManagerModules.default
              ./home.nix
              ({pkgs, ...}:{
                 targets.genericLinux.enable = true;
                 
users.tomas.shell = pkgs.zsh;
# users.users.tomas.shell = pkgs.zsh;
              })
            ];
          };
      };

      deploy = {
        nodes = {
          unraid = {
            hostname = "100.122.146.5";
            profiles.user = {
              user = "tomas";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.home-manager
                self.homeConfigurations."root@tower";
            };
          };
          enceladus = {
            hostname = "100.78.63.10";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.enceladus;
            };
          };
          unraidferdorie = {
            hostname = "100.89.172.46";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.unraidferdorie;
            };
          };
          utm-nixos = {
            hostname = "100.124.108.91";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.aarch64-linux.activate.nixos
                self.nixosConfigurations.utm-nixos;
            };
          };
          hyperv-nixos = {
            # hostname = "100.67.146.61";
            hostname = "192.168.1.74";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.hyperv-nixos;
            };
          };
          supermicro = {
            # hostname = "100.67.146.61";
            hostname = "192.168.1.77";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.supermicro;
            };
          };
          cfserve = {
            hostname = "100.70.39.116";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path =
                deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.cfserve;
            };
          };
        };
      };

      # checks = builtins.mapAttrs
      # (system: deployLib: deployLib.deployChecks self.deploy) deploy.lib;

      # packages = { self, flake-utils, ... }:
      #   flake-utils.lib.eachDefaultSystem (system:
      #     {

      #     });

      # packages.aarch64-darwin = {
      #   darwinVM = self.nixosConfigurations.darwinVM.config.system.build.vm;
      #   installiso = self.packages.default.installiso;
      # };
      #   #     utmiso = nixos-generators.nixosGenerate {
      #   #       # inherit nixpkgs pkgs;
      #   #       system = "aarch64-linux";
      #   #       specialArgs = inputs;
      #   #       modules = [
      #   #         self.nixosConfigurations.utm-nixos.config
      #   #         # ({ pkgs, ... }: { })
      #   #       ];
      #   #       format = "qcow";
      #   #     };
      #   enceladusiso = nixos-generators.nixosGenerate {
      #     system = "x86_64-linux";
      #     # specialArgs = inputs;
      #     pkgs = pkgsFor.x86_64-linux;

      #     specialArgs = { inherit inputs outputs; };
      #     modules = [ self.nixosConfigurations.enceladus.config ];
      #     format = "install-iso";
      #   };
      # };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {inherit system;};
    in {
      formatter = alejandra.defaultPackage.${system};

      packages = {
        darwinVM = self.nixosConfigurations.darwinVM.config.system.build.vm;
        # installiso = nixos-generators.nixosGenerate {
        #   format = "install-iso";
        #   system = "x86_64-linux";
        #   specialArgs = { inherit inputs outputs; };
        #   modules = [ ./installer.nix ];
        # };
        installiso =
          self.nixosConfigurations.live.config.system.build.isoImage;
        netboot =
          self.nixosConfigurations.netboot.config.system.build.toplevel;

        attic = import ./attic/attic.nix {
          inherit
            #pkgs
            attic
            ;
          pkgs = pkgsFor.x86_64-linux;
          pkgsLinux = pkgsFor."x86_64-linux";
        };
      };

      # formatter = alejandra.defaultPackage.${system};
      devShells = {
        default = import ./shell.nix {inherit pkgs system inputs;}; # {
        # inherit pkgs;
        # inherit (colmena.packages."${pkgs.system}") colmena;
        # };
        # python = import ./shells/python.nix;
      };
    });
}
