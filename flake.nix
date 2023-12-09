{
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    # buildMachines = /etc/nix/machines;

    extra-substituters =
      [ "https://cachix.cachix.org" "https://tomasharkema.cachix.org" ];
    extra-trusted-public-keys =
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA=";
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # nixos-wsl.url = "github:nix-community/NixOS-WSL";
    # nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # darwin = {
    #   url = "github:LnL7/nix-darwin";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy.url = "github:serokell/deploy-rs";
    colmena.url = "github:zhaofengli/colmena";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixos-generators, deploy, home-manager, nix
    , colmena, flake-utils, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      # systems =
      #   [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      # forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      # pkgsFor = lib.genAttrs systems (system:
      #   import nixpkgs {
      #     inherit system;
      #     config.allowUnfree = true;
      #   });
    in {

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;

      # devShell = pkgs.callPackage import ./shell.nix {
      #     inherit (colmena.packages."${pkgs.system}") colmena;
      #     inherit (deploy.packages."${pkgs.system}") deploy-rs;
      #   };

      colmena = import ./colmena.nix (inputs // { inherit inputs; });
      nixosConfigurations =
        import ./nixosConfigurations.nix (inputs // { inherit inputs; });

      # colmena.meta = {
      #   machinesFile = /etc/nix/machines;
      #   nixpkgs = import nixpkgs {
      #     system = "x86_64-linux";
      #     overlays = [ ];
      #   };
      # };
      #   # utm-ferdorie = { pkgs, modulesPath, ... }: {

      #   #   imports = [ ./overlays/desktop.nix ];

      #   #   networking.hostName = "utm-ferdorie";
      #   #   deployment.tags = [ "vm" ];
      #   #   nixpkgs.system = "aarch64-linux";
      #   #   deployment = {
      #   #     targetHost = "100.119.250.94";
      #   #     targetUser = "tomas";
      #   #   };
      #   #   boot.isContainer = true;
      #   # };

      #   hyperv-nixos = import ./machines/hyperv-nixos/default.nix;

      #   # cfserve = { pkgs, modulesPath, ... }: {
      #   #   nixpkgs.system = "x86_64-linux";
      #   #   imports = [
      #   #     (modulesPath + "/installer/scan/not-detected.nix")
      #   #     ./overlays/desktop.nix
      #   #     ./apps/steam.nix
      #   #     # ./overlays/efi.nix  
      #   #   ];

      #   #   deployment.tags = [ "bare" ];
      #   #   networking.hostName = "cfserve";

      #   #   deployment = {
      #   #     # targetHost = "cfserve.ling-lizard.ts.net";
      #   #     targetHost = "100.111.187.38";
      #   #     # targetHost = "192.168.2.199";
      #   #     targetUser = "root";
      #   #   };

      #   #   boot.loader.systemd-boot.enable = true;
      #   #   boot.loader.efi.canTouchEfiVariables = true;
      #   #   boot.initrd.availableKernelModules =
      #   #     [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      #   #   boot.initrd.kernelModules = [ ];
      #   #   boot.kernelModules = [ "kvm-intel" ];
      #   #   boot.extraModulePackages = [ ];

      #   #   fileSystems."/" = {
      #   #     device = "/dev/disk/by-uuid/ebc58c28-a634-468e-b5e8-67da630aa1ef";
      #   #     fsType = "ext4";
      #   #   };

      #   #   fileSystems."/boot" = {
      #   #     device = "/dev/disk/by-uuid/FBE1-15BC";
      #   #     fsType = "vfat";
      #   #   };
      #   # };

      #   unraidferdorie = import ./machines/unraidferdorie/default.nix;

      #   # tactical = { pkgs, ... }: {
      #   #   nixpkgs.system = "x86_64-linux";

      #   #   imports = [
      #   #     # ./overlays/qemu.nix
      #   #     # ./overlays/desktop.nix
      #   #     # ./overlays/efi.nix 
      #   #   ];

      #   #   deployment.tags = [ "vm" ];
      #   #   networking.hostName = "tactical";
      #   #   deployment = {
      #   #     targetHost = "100.83.189.162";
      #   #     # targetHost = "192.168.0.32";
      #   #     targetUser = "root";
      #   #   };
      #   #   boot.isContainer = true;
      #   # };
      # };

      deploy = {
        nodes = {
          enceladus = {
            hostname = "100.67.118.80";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.enceladus;
            };
          };
          unraidferdorie = {
            hostname = "192.168.0.18";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = deploy.lib.x86_64-linux.activate.nixos
                self.nixosConfigurations.unraidferdorie;
            };
          };
          utm-nixos = {
            hostname = "100.124.108.91";
            profiles.system = {
              user = "root";
              sshUser = "root";
              path = deploy.lib.aarch64-linux.activate.nixos
                self.nixosConfigurations.utm-nixos;
            };
          };
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy.lib;

    } // inputs.flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import inputs.nixpkgs { inherit system; };
      in {
        devShells = {
          default = import ./shell.nix {
            inherit pkgs;
            inherit (deploy.packages."${pkgs.system}") deploy-rs;
            inherit (colmena.packages."${pkgs.system}") colmena;
          };
        };

        #   packages = {
        #     utmiso = nixos-generators.nixosGenerate {
        #       # inherit nixpkgs pkgs;
        #       system = "aarch64-linux";
        #       specialArgs = inputs;
        #       modules = [
        #         self.nixosConfigurations.utm-nixos.config
        #         # ({ pkgs, ... }: { })
        #       ];
        #       format = "qcow";
        #     };
        #     enceladusiso = nixos-generators.nixosGenerate {
        #       # inherit nixpkgs pkgs;
        #       system = "x86_64-linux";
        #       specialArgs = inputs;
        #       modules = [ self.nixosConfigurations.enceladus.config ];
        #       format = "install-iso";
        #     };
        #   };
      });
}
