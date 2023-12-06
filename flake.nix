{
  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    buildMachines = /etc/nix/machines;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
  };

  outputs = { nixpkgs, ... }: {

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = _: true;

    colmena = {
      meta = {
        machinesFile = /etc/nix/machines;
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ ];
        };
        nodeNixpkgs = {
          utm = import nixpkgs {
            system = "aarch64-linux";
            overlays = [ ];
          };
        };
      };

      defaults = import ./overlays/defaults.nix;

      utm-nixos = { pkgs, ... }: {
        nixpkgs.system = "aarch64-linux";
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];
        networking.hostName = "utm-nixos";
        deployment.tags = [ "vm" ];
        deployment = {
          # targetHost = "100.121.109.15";
          targetHost = "10.211.70.5";
          targetUser = "root";
        };
        boot.isContainer = true;
      };

      # utm-ferdorie = { pkgs, modulesPath, ... }: {

      #   imports = [ ./overlays/desktop.nix ];

      #   networking.hostName = "utm-ferdorie";
      #   deployment.tags = [ "vm" ];
      #   nixpkgs.system = "aarch64-linux";
      #   deployment = {
      #     targetHost = "100.119.250.94";
      #     targetUser = "tomas";
      #   };
      #   boot.isContainer = true;
      # };

      enceladus = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        networking.hostName = "enceladus";
        deployment.tags = [ "bare" ];
        deployment = {
          targetHost = "100.93.81.142";
          targetUser = "root";
        };
        boot.isContainer = true;
      };

      hyperv-nixos = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        networking.hostName = "hyperv-nixos";
        deployment.tags = [ "vm" ];

        deployment = {
          targetHost = "100.64.161.30";
          # targetHost = "192.168.1.73";
          targetUser = "root";
        };

        virtualisation.hypervGuest.enable = true;
        boot.isContainer = true;
      };

      cfserve = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        deployment.tags = [ "bare" ];
        networking.hostName = "cfserve";

        deployment = {
          # targetHost = "cfserve.ling-lizard.ts.net";
          targetHost = "100.111.187.38";
          targetUser = "root";
        };

        boot.isContainer = true;
      };

      unraidferdorie = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";

        imports = [
          # ./overlays/qemu.nix
          ./overlays/desktop.nix
          # ./overlays/efi.nix 
        ];

        deployment.tags = [ "vm" ];
        networking.hostName = "unraidferdorie";
        deployment = {
          # targetHost = "100.69.121.116";
          targetHost = "192.168.0.18";
          targetUser = "root";
        };

        boot.isContainer = true;
      };
    };
  };
}
